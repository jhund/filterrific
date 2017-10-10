# -*- encoding: utf-8 -*-

$:.push File.expand_path('../lib', __FILE__)
require 'terriffilter/version'

Gem::Specification.new do |gem|
  gem.name = 'Terriffilter'
  gem.version = Terriffilter::VERSION
  gem.platform = Gem::Platform::RUBY

  gem.authors = ['Jo Hund']
  gem.email = 'jhund@clearcove.ca'
  gem.homepage = 'http://terriffilter.clearcove.ca'
  gem.licenses = ['MIT']
  gem.summary = 'A Rails engine plugin for filtering ActiveRecord lists.'
  gem.description = %(terriffilter is a Rails Engine plugin that makes it easy to filter, search, and sort your ActiveRecord lists.)
  gem.required_ruby_version = '>= 1.9.3'

  gem.files = Dir[
    'CHANGELOG*',
    'MIT-LICENSE',
    'Rakefile',
    'README*',
    '{app,bin,doc,lib,spec}/**/*'
  ]
end
