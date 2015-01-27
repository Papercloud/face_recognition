module FaceRecognition
  module Base
    extend ActiveSupport::Concern

    included do

      def self.facebook_id_column
        # Work out what sort of UID the user model is using
        return "uid" if ActiveRecord::Base.connection.column_exists?("#{self.table_name}", "uid")
        return "facebook_id" if ActiveRecord::Base.connection.column_exists?("#{self.table_name}", "facebook_id")
        return "fb_uid" if ActiveRecord::Base.connection.column_exists?("#{self.table_name}", "fb_uid")
      end
    end
  end
end
