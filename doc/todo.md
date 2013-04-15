To make it work on Rails 3.1:

* follow kaminari gem for recipe
* implement new model api
* leave view and controller as is
* bump version to 1.0.0 (not backwards compatible)
* add CSS and JS via asset pipeline

Later:
* build filterrific-recipes on github wiki
* update readme
* update view and controller apis

https://github.com/rails/jquery-rails/blob/master/lib/jquery/rails/railtie.rb

# Implementation Plan for Filterrific

## Version 0.1.0: Rebuild current Rails2 functionality

## Add DSL and scope generator
## Write specs (http://avdi.org/devblog/2011/04/07/rspec-is-for-the-literate/ also read comments about be_...!)
## Add Filterrific form builder

