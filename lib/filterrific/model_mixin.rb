module Filterrific::ModelMixin

  extend ActiveSupport::Concern

  module ClassMethods

    # Adds filterrific behavior to class when called like so:
    #
    # filterrific(
    #   :default_settings => { :sorted_by => "created_at_asc" },
    #   :filter_names => [:sorted_by, :search_query, :with_state]
    # )
    #
    # @params[Hash] options
    #    Required keys are:
    #     * :filter_names: a list of filter_names to be exposed by Filterrific
    #    Optional keys are:
    #     * :default_settings: default filter settings
    def filterrific(options)
      cattr_accessor :filterrific_default_settings
      cattr_accessor :filterrific_filter_names

      options.stringify_keys!

      # Raise exception if not filter_names are given
      self.filterrific_filter_names = (
        options['filter_names'] || options['scope_names'] || []
      ).map { |e| e.to_s }
      raise(ArgumentError, ":filter_names can't be empty")  if filterrific_filter_names.blank?

      self.filterrific_default_settings = (
        options['default_settings'] || options['defaults'] || {}
      ).stringify_keys
      # Raise exception if defaults contain keys that are not present in filter_names
      if (
        invalid_defaults = (filterrific_default_settings.keys - filterrific_filter_names)
      ).any?
        raise(ArgumentError, "Invalid default keys: #{ invalid_defaults.inspect }")
      end
    end

    # Returns AR relation based on given filterrific_param_set.
    #
    # ModelClass.filterrific_find(@filterrific_param_set)
    #
    def filterrific_find(filterrific_param_set)
      unless filterrific_param_set.is_a?(Filterrific::ParamSet)
        raise(ArgumentError, "Invalid Filterrific::ParamSet: #{ filterrific_param_set.inspect }")
      end

      # set initial ar_proxy to including class
      ar_proxy = self

      # apply filterrific params
      self.filterrific_filter_names.each do |filter_name|
        filter_param = filterrific_param_set.send(filter_name)
        next if filter_param.blank? # skip blank filter_params
        ar_proxy = ar_proxy.send(filter_name, filter_param)
      end

      ar_proxy
    end

  end

end
