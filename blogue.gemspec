$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "blogue/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "blogue"
  s.version     = Blogue::VERSION
  s.authors     = ["Maxim Chernyak"]
  s.email       = ["madfancier@gmail.com"]
  s.homepage    = "http://github.com/maxim/blogue"
  s.summary     = "Small static blog engine for Rails"
  s.description = "If it wasn't in BLOGUE, it wasn't in blogue."
  s.licenses    = ['MIT']

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1.rc1"

  s.add_development_dependency 'kramdown'
  s.add_development_dependency 'rouge'
  s.add_development_dependency 'pry'
end
