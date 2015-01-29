# -*- coding: utf-8 -*-
#
# Adds Filterrific methods ActionController instances
#
module Filterrific
  module ActionControllerExtension

  protected

    # @param model_class [Class]
    # @param filterrific_params [Hash] typically the Rails request params under
    #    the :filterrific key (params[:filterrific]), however can be any Hash.
    # @param opts [Hash]
    # @option opts [Array<String>, optional] :available_filters
    #   further restrict which of the filters specified in the model are
    #   available in this context.
    # @option opts [Hash, optional] :default_filter_params
    #   overrides the defaults specified in the model.
    # @option opts [String, Symbol, optional] :persistence_id
    #   defaults to "namespace/controller#action" string, used for session key
    #   and saved searches to isolate different filters' persisted params from
    #   each other.
    # @option opts [Hash, optional] :select_options
    #   these are available in the view to populate select lists and other
    #   dynamic values.
    # @return [Filterrific::ParamSet]
    def initialize_filterrific(model_class, filterrific_params, opts)
      f_params = (filterrific_params || {}).deep_stringify_keys
      opts = opts.stringify_keys
      pi = opts['persistence_id'] || compute_default_persistence_id

      if (f_params.delete('reset_filterrific'))
        # Reset query and session_persisted params
        session[pi] = nil
        redirect_to url_for({})  and return false # works with `or return` in calling action.
      end

      f_params = f_params.presence || # start with passed in params
                 session[pi].presence || # then try session persisted params
                 opts['default_filter_params'] || # then use passed in opts
                 model_class.filterrific_default_filter_params # finally use model_class defaults

      f_params.deep_stringify_keys!
      f_params.slice!(opts['available_filters'].map(&:to_s))  if opts['available_filters']

      filterrific = Filterrific::ParamSet.new(model_class, f_params)
      filterrific.select_options = opts['select_options']
      session[pi] = filterrific.to_hash
      filterrific
    end

    # Computes a default persistence id based on controller and action name
    def compute_default_persistence_id
      [controller_name, action_name].join('#')
    end

  end
end
