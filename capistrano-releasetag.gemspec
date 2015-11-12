# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "capistrano-releasetag"
  spec.version       = '1.0.0'
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
