# -*- encoding: utf-8 -*-
require File.expand_path('../lib/android-xml/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'android-xml'
  gem.version       = AndroidXml::Version
  gem.licenses      = ['BSD']

  gem.authors = ['Colin T.A. Gray']
  gem.email   = ['colinta@gmail.com']
  gem.summary     = %{Generates Android XML files.}
  gem.description = <<-DESC
Add this to your build process, and never write XML again!

Plus, you can have multiple files generated from one file.
DESC

  gem.homepage    = 'https://github.com/colinta/android-xml'

  gem.files       = Dir.glob('lib/**/*.rb')
  gem.files      << 'README.md'
  gem.test_files  = Dir.glob('spec/**/*.rb')

  gem.require_paths = ['lib']
  gem.add_development_dependency 'rspec'
end
