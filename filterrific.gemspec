# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'filterrific/version'

Gem::Specification.new do |gem|
  gem.name = 'filterrific'
  gem.version = Filterrific::VERSION
  gem.platform = Gem::Platform::RUBY

  gem.authors = ['Jo Hund']
  gem.email = 'jhund@clearcove.ca'
  gem.homepage = 'http://filterrific.clearcove.ca'
  gem.license  = 'MIT'
  gem.licenses = ['MIT']
  gem.summary = 'A Rails engine plugin for filtering ActiveRecord lists.'
  gem.description = %(Filterrific is a Rails Engine plugin that makes it easy to filter, search, and sort your ActiveRecord lists.)
  gem.required_ruby_version = '>= 1.9.3'

  gem.files = Dir[
    'CHANGELOG*',
    'MIT-LICENSE',
    'Rakefile',
    'README*',
    '{app,bin,doc,lib,spec}/**/*'
  ]
end
