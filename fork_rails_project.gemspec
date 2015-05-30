# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name         = "fork_rails_project"
  s.version      = "0.0.3"
  s.authors      = "Alexander Huber"
  s.email        = "alih83@gmx.de"
  s.homepage     = "https://github.com/alihuber/fork_rails_project"
  s.summary      = "Script to set up forks of existing rails apps/engines"
  s.description  = "Generates copies of existing app directories with automatic renaming/namespacing of contained files"

  s.files        = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.executables  = "fork-rails-project"
  s.require_path = "lib"
  s.license      = "MIT"

  s.add_runtime_dependency     "activesupport", "~> 4"
  s.add_development_dependency "rspec", "~> 3"
  s.add_development_dependency "pry", "~> 0"
end
