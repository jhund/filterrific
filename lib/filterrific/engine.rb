require 'rails'

module Filterrific
  class Engine < ::Rails::Engine

    # It's an engine so that we can add javascript and image assets
    # to the asset pipeline.

    require 'filterrific/param_set'

    initializer "filterrific.active_record_extension" do |app|
      require 'filterrific/active_record_extension'
      class ::ActiveRecord::Base
        extend Filterrific::ActiveRecordExtension::ClassMethods
      end
    end

    initializer "filterrific.action_view_extension" do |app|
      require 'filterrific/action_view_extension'
      class ::ActionView::Base
        include Filterrific::ActionViewExtension
      end
    end

  end
end
