$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "face_recognition/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "face_recognition"
  s.version     = FaceRecognition::VERSION
  s.authors     = ["Isaac Norman"]
  s.email       = ["idn@papercloud.com.au"]
  s.homepage    = "http://github.com/Papercloud/face_recognition"
  s.summary     = "Anon and Facebook User Auth"
  s.description = "Allows registration of anon and Facebook users in your rails app"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.1"
  s.add_dependency "fb_graph2", "~> 0.1.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', "~> 2.14.2"
  s.add_development_dependency 'capybara', "~> 2.2.1"
  s.add_development_dependency 'factory_girl_rails', "~> 4.4.1"
  s.add_development_dependency 'database_cleaner', "~> 1.2.0"
  s.add_development_dependency 'awesome_print', "~> 1.2.0"
end
