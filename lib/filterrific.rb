require 'filterrific/version'
require 'filterrific/engine'

module Filterrific

  # Wrapper around Filterrific::ParamSet initialization
  def self.new(a_resource_class, filterrific_params = {})
    Filterrific::ParamSet.new(a_resource_class, filterrific_params)
  end

end
