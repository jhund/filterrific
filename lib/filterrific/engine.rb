module Filterrific
  class Engine < ::Rails::Engine

    # It's an engine so that we can add javascript and image assets
    # to the asset pipeline.

    isolate_namespace Filterrific

    require 'filterrific/param_set'

    initializer "filterrific" do |app|

      ActiveSupport.on_load :active_record do
        require 'filterrific/active_record_extension'
        class ::ActiveRecord::Base
          extend Filterrific::ActiveRecordExtension::ClassMethods
        end
      end

      ActiveSupport.on_load :action_view do
        require 'filterrific/action_view_extension'
        class ::ActionView::Base
          include Filterrific::ActionViewExtension
        end
      end

      app.config.assets.precompile += %w(filterrific-spinner.gif)

    end

  end
end
