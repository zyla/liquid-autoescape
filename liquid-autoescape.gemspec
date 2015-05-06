# encoding: utf-8
lib = File.expand_path("../lib/", __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require "liquid/autoescape/version"

Gem::Specification.new do |s|
  s.name         = "liquid-autoescape"
  s.version      = Liquid::Autoescape::VERSION
  s.summary      = "Autoescape support for Liquid"
  s.authors      = ["Within3"]
  s.email        = ["it-operations@within3.com"]
  s.license      = "MIT"

  s.files        = %w(LICENSE README.md)
  s.files       += Dir.glob("lib/**/*")
  s.files       += Dir.glob("spec/**/*")
  s.test_files   = Dir.glob("spec/**/*")

  s.add_dependency "liquid", ">= 2.0", "< 4.0"

  s.add_development_dependency "appraisal", "~> 2.0"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 0.30"
end
