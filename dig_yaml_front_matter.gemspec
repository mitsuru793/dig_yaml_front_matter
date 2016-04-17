# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dig_yaml_front_matter/version'

Gem::Specification.new do |spec|
  spec.name          = "dig_yaml_front_matter"
  spec.version       = DigYamlFrontMatter::VERSION
  spec.authors       = ["mitsuru"]
  spec.email         = ["mitsuru793@gmail.com"]

  spec.summary       = %q{summary}
  spec.description   = %q{description}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ['dig_yaml_front_matter']#spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "front_matter_parser"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-test", '2.0.5'
  spec.add_development_dependency "terminal-notifier"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "fakefs"
end
