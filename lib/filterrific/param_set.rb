require 'active_support/all'
require 'digest/sha1'

module Filterrific

  # FilterParamSet is a container to store FilterParams
  class ParamSet

    attr_accessor :resource_class
    attr_accessor :select_options

    def initialize(a_resource_class, filterrific_params = {})
      self.resource_class = a_resource_class
      @select_options = {}

      # Use either passed in filterrific_params or resource class' default_settings.
      # Don't merge the hashes. This causes trouble if an option is set to nil
      # by the user, then it will be overriden by default_settings.
      # You might wonder "what if I want to change only one thing from the defaults?"
      # Persistence, baby. By the time you submit changes to one dimension, all the others
      # will be already initialized with the defaults.
      filterrific_params = resource_class.filterrific_default_settings  if filterrific_params.blank?
      filterrific_params.stringify_keys!
      filterrific_params = condition_filterrific_params(filterrific_params)
      define_attr_accessors_for_each_filter(filterrific_params)
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

    # Returns a signature that is unique to self's params
    def signature
      Digest::SHA1.hexdigest(to_hash.to_a.sort.to_s)
    end

    # Returns true if this Filterrific::ParamSet is not the model's default.
    # TODO: this doesn't work for procs. I need to evaluate the
    # filterrific_default_settings before comparing them to to_hash.
    #
    # def customized?
    #   resource_class.filterrific_default_settings != to_hash
    # end

  protected

    # Conditions params
    # @param[Hash] fp the filterrific params hash
    # @return[Hash] the conditioned params hash
    def condition_filterrific_params(fp)
      fp.each do |key, val|
        case
        when val.is_a?(Proc)
          # evaulate Procs
          fp[key] = val.call
        when val.is_a?(Array)
          # type cast integers in the array
          fp[key] = fp[key].map { |e| e =~ /^\d+$/ ? e.to_i : e }
        when val =~ /^\d+$/
          # type cast integer
          fp[key] = fp[key].to_i
        end
      end
      fp
    end

    # Defines attr accessors for each filter name on self and assigns
    # values based on fp
    # @param[Hash] fp filterrific_params
    def define_attr_accessors_for_each_filter(fp)
      resource_class.filterrific_filter_names.each do |filter_name|
        self.class.send(:attr_accessor, filter_name)
        v = fp[filter_name]
        self.send("#{ filter_name }=", v)  if v.present?
      end
    end

  end

end
