lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/tinifyme/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-tinifyme'
  spec.version       = Fastlane::Tinifyme::VERSION
  spec.author        = 'Danilo Becke'
  spec.email         = 'danilobecke@gmail.com'

  spec.summary       = 'Compress assets using tinypng.'
  spec.homepage      = "https://github.com/danilobecke/fastlane-plugin-tinifyme"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.6'

  spec.add_dependency 'tinify', '~> 1.6.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.213.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.12.1')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
end
