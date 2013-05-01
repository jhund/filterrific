if !(defined?(Rails) && Rails::VERSION::MAJOR >= 3)
  raise "Filterrific requires Rails 3 or greater"
end

require 'filterrific/version'
require 'filterrific/engine'

module Filterrific
end
