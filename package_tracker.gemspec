$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "package_tracker/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "package_tracker"
  s.version     = PackageTracker::VERSION
  s.authors     = ["Dylan Johnston"]
  s.email       = ["qdylanj@gmail.com"]
  s.homepage    = "http://john.ston.ca"
  s.summary     = "FedEx / DHL package tracker helper"
  s.description = "Easily track FedEx or DHL shipments."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
end
