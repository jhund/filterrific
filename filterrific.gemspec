# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "filterrific/version"

Gem::Specification.new do |gem|
  gem.name = 'filterrific'
  gem.version = Filterrific::VERSION
  gem.platform = Gem::Platform::RUBY
  gem.authors = ["Jo Hund"]
  gem.email = 'jhund@clearcove.ca'
  gem.homepage = 'http://github.com/jhund/filterrific'
  gem.summary = "The Rails User Interface solution for filtering your ActiveRecord lists."
  gem.description = %(
    The Rails User Interface solution for filtering your ActiveRecord lists:

    * Built from the ground up for Rails3
    * Build filter forms with ease
    * Filter ActiveRecord lists using AR scopes
    * Shuttle filter parameters from view to controller to model in a RESTful way
    * Auto-generate scopes for AR associations (Planned)
    * Form builder for filter UI forms (Planned)
  )

  gem.files = `git ls-files`.split("\n")
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", "~> 3.1.3"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "yard", ">= 0"

end
