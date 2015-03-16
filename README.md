# Face Recognition

A simple way to add both anonymous and Omniauthed users to your Rails Application.

At the moment we are just supporting Facebook authentication on the omniauth side of things. Other omni-auth methods will be added in in the future

## Installation.

Add the gem to your Gemfile

`gem 'face_recognition'`

and then install with `bundle install`

## Getting started

### Models

You require 3 models for this to work:

```
class User < ActiveRecord::Base

class FacebookUser < User

class AnonymousUser < User
```

The `User` model can actually be named whatever you want, as long as the other models inherit from it. `FacebookUser` and `AnonymousUser` must be named exactly as specified, so that we are able to switch an anonymous user to a Facebook one when they decide to sign up.

### Base User Model

Add the following to `/models/user.rb` (or the model you are using in place of User)

```
class User < ActiveRecord::Base
  include FaceRecognition::Base

  # your code here

end
```


### Facebook Users

Add the following to your `/models/facebook_user.rb` 

```
class FacebookUser < User
  include FaceRecognition::OmniAuth

  # your code here
end
```

This will add the necessary callbacks for omniauth. It does however make a number of assumptions about the fields that are on the model, but we have tried to make them as dynamic as possible.

These are the column options that are currently supported:

**Required Columns:**

* `email`
* `password` (this is not used, but is required by devise)
* `provider`
* ONE of the *ID Columns* below
* ONE for the *Authentication Columns* below

**Name Columns:**

* `name`
* `first_name`
* `last_name`
* `full_name`
* `display_name`

**ID Columns**
* `uid`
* `facebook_id`
* `fb_uid`

**Authentication Columns:**
* `oauth_token`
* `omniauth_token`
* `facebook_token`
* `fb_access_token`

**User Photo Columns:**

* `profile_image_url`
* `cover_image_url`
* `profile_photo_url`
* `cover_photo_url`
* `image_url`
* `photo_url`
* `avatar_url`
* `remote_image_url` (Carrierwave)
* `remote_avatar_url` (Carrierwave)

**Other User Info Columns:**

* `birthday`
* `dob`
* `date_of_birth`
* `d_o_b`
* `gender`

### Anonymous Users

Add the following to `models/anonymous_user.rb` file.

```
class AnonymousUser < User
  include FaceRecognition::Anonymous

  # your code here

end
```

This gives you the methods to link an anonymous user to a Facebook user when creating a session token.

### Facebook Tokens

The gem is currently using the assumption that your Facebook credentials are currently stored as environment variables, with the following keys:

```
FACEBOOK_APP_ID=
FACEBOOK_SECRET=
```

The gem will not work if these are not set correctly

### Controllers

At the moment there is not a controller built into the gem, but below is an example sessions controller that can be used to login users, as well as linking anonymous users to Facebook Users.

**sessions_controller.rb**

```
def create
  user = FbGraph2::User.me(params[:user][:oauth_token])
  auth_request = user.fetch rescue nil

  if auth_request
    if params[:user][:id]
      authenticate_user!
      user = AnonymousUser.link_to_fb(params[:user][:id], auth_request)
      if user and current_user.id == params[:user][:id]
        current_user.destroy
      end
    else
      user = FacebookUser.from_omniauth(auth_request)
    end
    return respond_with(user, root: "user", serializer: NewUserSerializer)
  end
  respond_with({}, status: 400)
end
```

The registrations controller is fairly similar to the standard registrations controller, but because we have multiple user types we need to override the `resource_class` when we are updating the user.

In the below example we are using [`inherited_resources`](https://github.com/josevalim/inherited_resources)

**registrations_controller.rb**

```
def create
  create! do |format|
    format.json {respond_with(@user, serializer: NewUserSerializer)}
  end
end

def update
  @user = resource_class.find(current_user.id)
  update!
end

def resource_class
  #turn the type attribute to constants due to multiple user types
  case params[:user][:type]
  when "FacebookUser"
    return FacebookUser
  when "AnonymousUser"
    return AnonymousUser
  else
    return User
  end
end
```

### Future Features

Eventually we will turn this into a full Rails engine and include the controllers in the gem. For the moment we are leaving them out so that you can customise them to your needs.

**Other future features:**

* add [simple_token_authentication](https://github.com/gonzalo-bulnes/simple_token_authentication) into the gem.
* Allow flexibility with model names.




