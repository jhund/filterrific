# -*- coding: utf-8 -*-

require 'active_support/all'
require 'digest/sha1'

module Filterrific

  # FilterParamSet is a container to store FilterParams
  class ParamSet

    attr_accessor :model_class
    attr_accessor :select_options

    # Initializes a new Filterrific::ParamSet. This is the core of Filterrific
    # where all the action happens.
    # @param a_model_class [Class] the class you want to filter records of.
    # @param filterrific_params [Hash, optional] the filter params, falls back
    #   to model_class' default_settings.
    # @return [Filterrific::ParamSet]
    def initialize(a_model_class, filterrific_params = {})
      self.model_class = a_model_class
      @select_options = {}

      # Use either passed in filterrific_params or resource class' default_settings.
      # Don't merge the hashes. This causes trouble if an option is set to nil
      # by the user, then it will be overriden by default_settings.
      # You might wonder "what if I want to change only one thing from the defaults?"
      # Persistence, baby. By the time you submit changes to one filter, all the others
      # will be already initialized with the defaults.
      filterrific_params = model_class.filterrific_default_filter_params  if filterrific_params.blank?
      if defined?(ActionController::Parameters) && filterrific_params.is_a?(ActionController::Parameters)
        permissible_filter_params = []
        model_class.filterrific_available_filters.each do |p|
          permissible_filter_params << (filterrific_params[p].is_a?(Hash) ? { p => filterrific_params[p].keys } : p)
        end
        filterrific_params = filterrific_params.permit(permissible_filter_params).to_h.stringify_keys
      else
        filterrific_params.stringify_keys!
      end
      filterrific_params = condition_filterrific_params(filterrific_params)
      define_and_assign_attr_accessors_for_each_filter(filterrific_params)
    end

    # A shortcut to run the ActiveRecord query on model_class. Use this if
    # you want to start with the model_class, and not an existing ActiveRecord::Relation.
    # Allows `@filterrific.find` in controller instead of
    # `ModelClass.filterrific_find(@filterrific)`
    def find
      model_class.filterrific_find(self)
    end

    # Returns Filterrific::ParamSet as hash (used for URL params and serialization)
    # @return [Hash] with stringified keys
    def to_hash
      {}.tap { |h|
        model_class.filterrific_available_filters.each do |filter_name|
          param_value = self.send(filter_name)
          case
          when param_value.blank?
            # do nothing
          when param_value.is_a?(Proc)
            # evaluate Proc so it can be serialized
            h[filter_name] = param_value.call
          when param_value.is_a?(OpenStruct)
            # convert OpenStruct to hash
            h[filter_name] = param_value.marshal_dump
          else
            h[filter_name] = param_value
          end
        end
      }
    end

    # Returns params as JSON string.
    # @return [String]
    def to_json
      to_hash.to_json
    end

  protected

    # Conditions params: Evaluates Procs and type casts integer values.
    # @param fp [Hash] the filterrific params hash
    # @return[Hash] the conditioned params hash
    def condition_filterrific_params(fp)
      fp.each do |key, val|
        case
        when val.is_a?(Proc)
          # evaluate Procs
          fp[key] = val.call
        when val.is_a?(Array)
          # type cast integers in the array
          fp[key] = fp[key].map { |e| e =~ integer_detector_regex ? e.to_i : e }
        when val.is_a?(Hash)
          # type cast Hash to OpenStruct so that nested params render correctly
          # in the form
          fp[key] = OpenStruct.new(fp[key])
        when val =~ integer_detector_regex
          # type cast integer
          fp[key] = fp[key].to_i
        end
      end
      fp
    end

    # Regex to detect if str represents and int
    def integer_detector_regex
      /\A-?([1-9]\d*|0)\z/
    end

    # Defines attr accessors for each available_filter on self and assigns
    # values based on fp.
    # @param fp [Hash] filterrific_params with stringified keys
    def define_and_assign_attr_accessors_for_each_filter(fp)
      model_class.filterrific_available_filters.each do |filter_name|
        self.class.send(:attr_accessor, filter_name)
        v = fp[filter_name]
        self.send("#{ filter_name }=", v)  if v.present?
      end
    end

  end

end
