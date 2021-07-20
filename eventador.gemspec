# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eventador/version'

Gem::Specification.new do |spec|
  spec.name          = "eventador"
  spec.version       = Eventador::VERSION
  spec.authors       = ['Daniel Huckstep']
  spec.email         = ['darkhelmet@darkhelmetlive.com']
  spec.summary       = %q{Simple callbacks/lightweight events on procs.}
  spec.description   = %q{Simple callbacks/lightweight events on procs.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', ">= 2.2.10"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
