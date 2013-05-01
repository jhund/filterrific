require 'rails'

module Filterrific
  class Engine < ::Rails::Engine

    ## Should we use this: ?? isolate_namespace Filterrific

    # it's an engine so that we can add static assets to the asset pipeline

    initializer "filterrific.model_mixin" do |app|
      require 'filterrific/model_mixin'
      class ActiveRecord::Base
        include Filterrific::ModelMixin
      end
      require 'filterrific/param_set'
    end

    initializer "filterrific.view_helpers" do |app|
      require 'filterrific/view_helpers'
      class ActionView::Base
        include Filterrific::ViewHelpers
      end
    end

  end
end
