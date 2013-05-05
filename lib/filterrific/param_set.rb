require 'active_support/all'

module Filterrific

  # FilterParamSet is a container to store FilterParams
  class ParamSet

    attr_accessor :resource_class

    def initialize(a_resource_class, filterrific_params = {})

      self.resource_class = a_resource_class

      # Use either passed in filterrific_params or resource class' default_settings.
      # Don't merge the hashes. This causes trouble if an option is set to nil
      # by the user, then it will be overriden by default_settings.
      # You might wonder "what if I want to change only one thing from the defaults?"
      # Persistence, baby. By the time you submit changes to one dimension, all the others
      # will be already initialized with the defaults.
      filterrific_params = resource_class.filterrific_default_settings  if filterrific_params.blank?

      # force all keys to strings
      filterrific_params.stringify_keys!

      # condition filterrific_params
      filterrific_params.each do |key, val|
        case
        when val.is_a?(Proc)
          # evaulate Procs
          filterrific_params[key] = val.call
        when val.is_a?(Array)
          # type cast integers in the array
          filterrific_params[key] = filterrific_params[key].map { |e| e =~ /^\d+$/ ? e.to_i : e }
        when val =~ /^\d+$/
          # type cast integer
          filterrific_params[key] = filterrific_params[key].to_i
        end
      end

      # Define attr_accessor for each filterrific_filter_name
      # on Filterrific::ParamSet instance and assign values from options
      resource_class.filterrific_filter_names.each do |filter_name|
        self.class.send(:attr_accessor, filter_name)
        v = filterrific_params[filter_name]
        self.send("#{ filter_name }=", v)  if v.present?
      end

    end

    # Returns Filterrific::ParamSet as hash (used for URL params and serialization)
    def to_hash
      {}.tap { |h|
        resource_class.filterrific_filter_names.each do |filter_name|
          param_value = self.send(filter_name)
          case
          when param_value.blank?
            # do nothing
          when param_value.is_a?(Proc)
            # evaluate Proc so it can be serialized
            h[filter_name] = param_value.call
          else
            h[filter_name] = param_value
          end
        end
      }
    end

    def to_json
      to_hash.to_json
    end

    # Returns true if this Filterrific::ParamSet is not the model's default.
    # TODO: this doesn't work for procs. I need to evaluate the 
    # filterrific_default_settings before comparing them to to_hash.
    #
    # def customized?
    #   resource_class.filterrific_default_settings != to_hash
    # end

  end

end
