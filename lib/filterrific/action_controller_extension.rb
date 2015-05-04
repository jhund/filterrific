# -*- coding: utf-8 -*-
#
# Adds Filterrific methods ActionController instances
#
module Filterrific
  module ActionControllerExtension

    include HasResetFilterrificUrlMixin

  protected

    # @param model_class [Class]
    # @param filterrific_params [Hash] typically the Rails request params under
    #    the :filterrific key (params[:filterrific]), however can be any Hash.
    # @param opts [Hash, optional]
    # @option opts [Array<String>, optional] :available_filters
    #   further restrict which of the filters specified in the model are
    #   available in this context.
    # @option opts [Hash, optional] :default_filter_params
    #   overrides the defaults specified in the model.
    # @option opts [String, Symbol, optional] :persistence_id
    #   defaults to "namespace/controller#action" string, used for session key
    #   and saved searches to isolate different filters' persisted params from
    #   each other. Set to false to turn off session persistence.
    # @option opts [Hash, optional] :select_options
    #   these are available in the view to populate select lists and other
    #   dynamic values.
    # @return [Filterrific::ParamSet]
    def initialize_filterrific(model_class, filterrific_params, opts = {})
      # We used #deep_stringify_keys, however that breaks on Rails 3.x, so we
      # went back to #stringify_keys which should be sufficient.
      f_params = (filterrific_params || {}).stringify_keys
      opts = opts.stringify_keys
      pers_id = if false == opts['persistence_id']
        nil
      else
        opts['persistence_id'] || compute_default_persistence_id
      end

      if (f_params.delete('reset_filterrific'))
        # Reset query and session_persisted params
        session[pers_id] = nil  if pers_id
        redirect_to url_for({})  and return false # requires `or return` in calling action.
      end

      f_params = compute_filterrific_params(model_class, f_params, opts, pers_id)

      filterrific = Filterrific::ParamSet.new(model_class, f_params)
      filterrific.select_options = opts['select_options']
      session[pers_id] = filterrific.to_hash  if pers_id
      filterrific
    end

    # Computes a default persistence id based on controller and action name
    def compute_default_persistence_id
      [controller_name, action_name].join('#')
    end

    # Computes filterrific params using a number of strategies. Limits params
    # to 'available_filters' if given via opts.
    # @param model_class [ActiveRecord::Base]
    # @param filterrific_params [Hash]
    # @param opts [Hash]
    # @param persistence_id [String, nil]
    def compute_filterrific_params(model_class, filterrific_params, opts, persistence_id)
      r = (
        filterrific_params.presence || # start with passed in params
        (persistence_id && session[persistence_id].presence) || # then try session persisted params if persistence_id is present
        opts['default_filter_params'] || # then use passed in opts
        model_class.filterrific_default_filter_params # finally use model_class defaults
      ).stringify_keys
      r.slice!(*opts['available_filters'].map(&:to_s))  if opts['available_filters']
      r
    end

  end
end
