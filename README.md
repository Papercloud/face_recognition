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
