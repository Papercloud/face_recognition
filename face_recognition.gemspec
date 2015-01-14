$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "face_recognition/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "face_recognition"
  s.version     = FaceRecognition::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FaceRecognition."
  s.description = "TODO: Description of FaceRecognition."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.9"

  s.add_development_dependency "sqlite3"
end
