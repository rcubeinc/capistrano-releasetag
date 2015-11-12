# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/releasetag/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-releasetag"
  spec.version       = Capistrano::Releasetag::VERSION
  spec.authors       = ["rcubeinc_hikime"]
  spec.email         = ["hikime@rcubeinc.com"]

  spec.summary       = %q{capistrano deploy and create tags}
  spec.description   = %q{capistrano deploy and create tags}
  spec.files       = `git ls-files lib`.split(/\n/) + %w{ README.md LICENSE }
  spec.license       = "MIT"

  spec.require_paths = ["lib"]

  spec.add_dependency 'capistrano', '>= 3.2.0'
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
