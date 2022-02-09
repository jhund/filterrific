# -*- coding: utf-8 -*-

if ![5,6,7].include?(Rails::VERSION::MAJOR)
  raise "\n\nThis version of Filterrific only works with Rails 5, 6 and 7.\nPlease see the Filterrific README for the correct version of Filterrific to use with your version of Rails!\n\n"
end

require 'filterrific/version'
require 'filterrific/engine'

module Filterrific
end
