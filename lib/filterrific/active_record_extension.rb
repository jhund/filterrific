#
# Adds filterrific methods to ActiveRecord::Base and sub classes.
#
require 'filterrific/param_set'

module Filterrific::ActiveRecordExtension

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

      assign_filterrific_filter_names(options)
      validate_filterrific_filter_names
      assign_filterrific_default_settings(options)
      validate_filterrific_default_settings
    end

    # Returns ActiveRecord relation based on given filterrific_param_set.
    # Use like so:
    # ModelClass.filterrific_find(@filterrific_param_set)
    #
    # @param[Filterrific::ParamSet] filterrific_param_set
    # @return[ActiveRecord::Relation] an ActiveRecord relation.
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

  protected

    def assign_filterrific_filter_names(options)
      self.filterrific_filter_names = (
        options['filter_names'] || options['scope_names'] || []
      ).map { |e| e.to_s }
    end

    def validate_filterrific_filter_names
      # Raise exception if not filter_names are given
      raise(ArgumentError, ":filter_names can't be empty")  if filterrific_filter_names.blank?
    end

    def assign_filterrific_default_settings(options)
      self.filterrific_default_settings = (
        options['default_settings'] || options['defaults'] || {}
      ).stringify_keys
    end

    def validate_filterrific_default_settings
      # Raise exception if defaults contain keys that are not present in filter_names
      if (
        invalid_defaults = (filterrific_default_settings.keys - filterrific_filter_names)
      ).any?
        raise(ArgumentError, "Invalid default keys: #{ invalid_defaults.inspect }")
      end
    end

  end

end
