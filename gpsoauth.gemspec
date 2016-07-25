# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gpsoauth/version'

Gem::Specification.new do |spec|
  spec.name          = "gpsoauth-rb"
  spec.version       = Gpsoauth::VERSION
  spec.authors       = ["Sawyer Charles"]
  spec.email         = ["xssc@users.noreply.github.com"]

  spec.summary       = "gpsoauth for ruby"
  spec.description   = "Direct ruby port of the gpsoauth python library. (https://github.com/simon-weber/gpsoauth)"
  spec.homepage      = "https://github.com/xssc/gpsoauth"
  spec.license       = "MIT"

  spec.files         = Dir.glob('lib/**/*')
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "typhoeus", "~> 1.1"
end
