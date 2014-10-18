require 'filterrific/param_set'
require 'filterrific/action_view_extension'
require 'filterrific/active_record_extension'

module Filterrific
  class Engine < ::Rails::Engine

    # It's an engine so that we can add javascript and image assets
    # to the asset pipeline.

    isolate_namespace Filterrific

    ActiveSupport.on_load :active_record do
      extend Filterrific::ActiveRecordExtension
    end

    ActiveSupport.on_load :action_view do
      include Filterrific::ActionViewExtension
    end

    initializer "filterrific" do |app|
      app.config.assets.precompile += %w(filterrific-spinner.gif)
    end

  end
end
