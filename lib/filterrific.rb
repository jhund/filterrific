# -*- coding: utf-8 -*-

if Rails::VERSION::MAJOR != 5
  raise "\n\nThis version of Filterrific only works with Rails 5.x.\nPlease see the Filterrific README for the correct version of Filterrific to use with your version of Rails!\n\n"
end

require 'filterrific/version'
require 'filterrific/engine'

module Filterrific
end
