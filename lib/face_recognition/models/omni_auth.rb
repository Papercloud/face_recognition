module FaceRecognition
  module OmniAuth
    extend ActiveSupport::Concern

    included do

      # Take the auth hash from the Omniauth callback and create / update the user
      def self.from_omniauth(auth)
        # Find or create the user
        user = nil
        if FacebookUser.exists?("#{self.table_name}.#{self.facebook_id_column}" => auth.id)
          user = FacebookUser.where("#{self.table_name}.#{self.facebook_id_column} =?", auth.id).first
        else
          user = FacebookUser.new
        end

        # Assign the Facebook ID. because we are calling the SQL in the first_or_create it doesn't update that column
        user[self.facebook_id_column.to_sym] = auth.id

        # Dynamically try and set the users name, no matter how they have it set up
        user.first_name = auth.first_name if user.respond_to? :first_name=
        user.last_name = auth.last_name if user.respond_to? :last_name=
        user.name = auth.name if user.respond_to? :name=
        user.full_name = auth.name if user.respond_to? :full_name=
        user.display_name = auth.name if user.respond_to? :display_name=

        # Set their token and provider
        user.oauth_token = auth.access_token if user.respond_to? :oauth_token=
        user.omniauth_token = auth.access_token if user.respond_to? :omniauth_token=
        user.facebook_token = auth.access_token if user.respond_to? :facebook_token=
        user.fb_access_token = auth.access_token if user.respond_to? :fb_access_token=
        user.provider = 'facebook' if user.respond_to? :provider=

        # User images
        user.profile_image_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :profile_image_url=
        user.profile_photo_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :profile_photo_url=
        user.cover_image_url = auth.try(:cover) if user.respond_to? :cover_image_url=
        user.cover_photo_url = auth.try(:cover) if user.respond_to? :cover_photo_url=
        user.image_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :image_url=
        user.photo_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :photo_url=
        user.avatar_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :avatar_url=
        user.remote_image_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :remote_image_url=
        user.remote_avatar_url = "http://graph.facebook.com/#{auth.id}/picture?type=large" if user.respond_to? :remote_avatar_url=

        # Regular Devise columns set
        user.email = auth.email || ''
        user.password = Devise.friendly_token[0, 20]

        # Extra Info that we can grab
        user.birthday = auth.raw_attributes.birthday if user.respond_to? :birthday=
        user.date_of_birth = auth.raw_attributes.birthday if user.respond_to? :date_of_birth=
        user.dob = auth.raw_attributes.birthday if user.respond_to? :dob=
        user.d_o_b = auth.raw_attributes.try(:birthday) if user.respond_to? :d_o_b=
        user.gender = auth.try(:gender) if user.respond_to? :gender=

        user.save
        # Extend the Users facebook token so that it does not expire
        user.extend_fb_token(facebook_id_column)

        user
      end

      def self.extend_fb_token(id, column_name)
        user = FacebookUser.where(id: id).first
        return unless user
        fb_auth = FbGraph2::Auth.new(ENV['FB_APP_ID'], ENV['FB_SECRET'])
        fb_auth.fb_exchange_token=(user.fb_access_token)
        user.fb_access_token = fb_auth.access_token!.access_token
        user.save
      end

      def extend_fb_token(column_name)
        self.class.delay.extend_fb_token(self.id, column_name)
      end
    end
  end
end


