# -*- coding: utf-8 -*-

require 'terriffilter/param_set'

require 'terriffilter/has_reset_terriffilter_url_mixin'

require 'terriffilter/action_controller_extension'
require 'terriffilter/action_view_extension'
require 'terriffilter/active_record_extension'

module Terriffilter
  class Engine < ::Rails::Engine

    # It's an engine so that we can add javascript and image assets
    # to the asset pipeline.

    isolate_namespace Terriffilter

    ActiveSupport.on_load :action_controller do
      include Terriffilter::ActionControllerExtension
    end

    ActiveSupport.on_load :action_view do
      include Terriffilter::ActionViewExtension
    end

    ActiveSupport.on_load :active_record do
      extend Terriffilter::ActiveRecordExtension
    end

  end
end
