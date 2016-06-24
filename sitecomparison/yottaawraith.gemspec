# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yottaawraith/version'

Gem::Specification.new do |spec|
  spec.name = 'yottaawraith'
  spec.version = YottaaWraith::VERSION
  spec.authors = 'Tag Frothingham'
  spec.email = 'tag.frothingham@yottaa.com'
  spec.summary = 'Wraith is a screenshot comparison tool, created by developers at BBC News.'
  spec.description = 'Wraith is a screenshot comparison tool, created by developers at BBC News.  This version is modified to be used for Yottaa to test sites'
  spec.homepage = 'https://github.com/BBC-News/wraith'
  spec.license = 'Apache 2'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) } #
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry', '~> 0'
  #spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'rake', '~> 0'
  spec.add_runtime_dependency 'image_size'
  spec.add_runtime_dependency 'anemone', '~> 0'
  spec.add_runtime_dependency 'robotex'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'log4r'
  spec.add_runtime_dependency 'thor', '~> 0'
  spec.add_runtime_dependency 'parallel', '~> 0'
  spec.add_runtime_dependency 'casperjs'
  spec.add_runtime_dependency 'rspec'
  spec.add_runtime_dependency 'wraith'
  spec.add_runtime_dependency 'rspec_junit_formatter'
  spec.add_runtime_dependency 'net-dns'
end