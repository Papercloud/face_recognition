require "face_recognition/engine"

module FaceRecognition
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  #do nothing
end

# Load All the stuff we need
require 'face_recognition/models/base'
require 'face_recognition/models/omni_auth'
require 'face_recognition/models/anonymous'

if defined? Rails
  require 'face_recognition/railtie'
end
