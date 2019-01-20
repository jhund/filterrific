# -*- coding: utf-8 -*-
#
# Adds Filterrific methods ActionController instances
#
module Filterrific
  module ActionControllerExtension

    include HasResetFilterrificUrlMixin

  protected

    # @param model_class [Class]
    # @param filterrific_params [ActionController::Params, Hash] typically the
    #    Rails request params under the :filterrific key (params[:filterrific]),
    #    however can be any Hash.
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
    # @option opts [Boolean, optional] :sanitize_params
    #   if true, sanitizes all filterrific params to prevent reflected (or stored) XSS attacks.
    #   Defaults to true.
    # @return [Filterrific::ParamSet]
    def initialize_filterrific(model_class, filterrific_params, opts = {})
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
    # @param filterrific_params [ActionController::Params, Hash]
    # @param opts [Hash]
    # @option opts [Boolean, optional] "sanitize_params"
    #   if true, sanitizes all filterrific params to prevent reflected (or stored) XSS attacks.
    #   Defaults to true.
    # @param persistence_id [String, nil]
    def compute_filterrific_params(model_class, filterrific_params, opts, persistence_id)
      opts = { "sanitize_params" => true }.merge(opts.stringify_keys)
      r = (
        filterrific_params.presence || # start with passed in params
        (persistence_id && session[persistence_id].presence) || # then try session persisted params if persistence_id is present
        opts['default_filter_params'] || # then use passed in opts
        model_class.filterrific_default_filter_params # finally use model_class defaults
      ).stringify_keys
      r.slice!(*opts['available_filters'].map(&:to_s))  if opts['available_filters']
      # Sanitize params to prevent reflected XSS attack
      if opts["sanitize_params"]
        r.each { |k,v| r[k] = sanitize_filterrific_param(r[k]) }
      end
      r
    end

    # Sanitizes value to prevent xss attack.
    # Uses Rails ActionView::Helpers::SanitizeHelper.
    # @param val [Object] the value to sanitize. Can be any kind of object. Collections
    #   will have their members sanitized recursively.
    def sanitize_filterrific_param(val)
      case val
      when Array
        # Return Array
        val.map { |e| sanitize_filterrific_param(e) }
      when Hash
        # Return Hash
        val.inject({}) { |m, (k,v)| m[k] = sanitize_filterrific_param(v); m }
      when NilClass
        # Nothing to do, use val as is
        val
      when String
        helpers.sanitize(val)
      else
        # Nothing to do, use val as is
        val
      end
    end

  end
end
