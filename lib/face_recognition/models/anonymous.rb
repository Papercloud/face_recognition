module FaceRecognition
  module Anonymous
    extend ActiveSupport::Concern

    included do
      before_create :generate_password

      def self.link_to_fb(id, auth)
        user = nil
        if FacebookUser.exists?(User.facebook_id_column.to_sym => auth.id)
          user = FacebookUser.where(User.facebook_id_column.to_sym => auth.id).first
        else
          user = find(id)
          user[facebook_id_column.to_sym] = auth.id
          user.type = "FacebookUser"
          # We don't validate here because we are about to update all the details
          user.save(validate: false)
          FacebookUser.from_omniauth(auth)
        end

        return user
      end

      def generate_password
        self.password = Devise.friendly_token[0,20]
      end
    end
  end
end
