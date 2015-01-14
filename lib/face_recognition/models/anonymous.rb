module FaceRecognition
  module Anonymous
    extend ActiveSupport::Concern

    included do

      before_create :generate_password

      def self.link_to_fb(id, auth)
        user = nil
        if FacebookUser.exists?(self.class.facebook_id_column.to_sym => auth.id)
          user = FacebookUser.where(self.class.facebook_id_column.to_sym => auth.id).first
        else
          user = find(id)
          user.update(
            fb_uid: auth.id, type: "FacebookUser",
            display_name: "#{auth.first_name} #{auth.last_name[0]}.",
            fb_access_token:  auth.access_token)
        end

        return user
      end

      def generate_password
        self.password = Devise.friendly_token[0,20]
      end
    end
  end
end
