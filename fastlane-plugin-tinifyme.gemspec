lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/tinifyme/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-tinifyme'
  spec.version       = Fastlane::Tinifyme::VERSION
  spec.author        = 'Danilo Becke'
  spec.email         = 'danilobecke@gmail.com'

  spec.summary       = 'Compress assets using TinyPNG.'
  spec.homepage      = "https://github.com/danilobecke/fastlane-plugin-tinifyme"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_dependency('tinify', '~> 1.6.0')
  spec.metadata['rubygems_mfa_required'] = 'true'
end
