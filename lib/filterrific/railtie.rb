require 'filterrific'
require 'rails'

module Filterrific

  class Railtie < Rails::Railtie
    
    initializer "filterrific.model_mixin" do |app|
      require 'filterrific/model_mixin'
      ActiveRecord::Base.send(:include, Filterrific::ModelMixin)
      require 'filterrific/param_set'
    end
    
    initializer "filterrific.view_helpers" do |app|
      require 'filterrific/view_helpers'
      ActionView::Base.send(:include, Filterrific::ViewHelpers)
    end
    
    # to_prepare block is executed once in production and before each request in development
    # config.to_prepare do
    # end

  end
  
end
