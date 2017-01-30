# -*- coding: utf-8 -*-
#
# Adds Filterrific methods to ActiveRecord::Base model_class.
#
require 'filterrific/param_set'

module Filterrific
  module ActiveRecordExtension

    # Adds Filterrific behavior to class when called like so:
    #
    # filterrific(
    #   :available_filters => [:sorted_by, :search_query, :with_state]
    #   :default_filter_params => { :sorted_by => "created_at_asc" },
    # )
    #
    # @params opts [Hash] with either string or symbol keys, will be stringified.
    # @option opts [Array<String, Symbol>] available_filters: a list of filters to be exposed by Filterrific.
    # @option opts [Hash, optional] default_filter_params: default filter parameters
    # @return [void]
    def filterrific(opts)
      class << self
        attr_accessor :filterrific_available_filters
        attr_accessor :filterrific_default_filter_params
      end
      self.filterrific_available_filters = []

      opts.stringify_keys!

      # define_sorted_by_scope(opts['sorted_by'])  if opts['sorted_by']
      # define_search_query_scope(opts['search_query'])  if opts['search_query']

      assign_filterrific_available_filters(opts)
      validate_filterrific_available_filters
      assign_filterrific_default_filter_params(opts)
      validate_filterrific_default_filter_params

    end

    # Returns ActiveRecord relation based on filterrific_param_set.
    # Use like so: `ModelClass.filterrific_find(@filterrific)`
    #
    # @param filterrific_param_set [Filterrific::ParamSet]
    # @return [ActiveRecord::Relation] with filters applied
    def filterrific_find(filterrific_param_set)
      unless filterrific_param_set.is_a?(Filterrific::ParamSet)
        raise(
          ArgumentError,
          "Invalid Filterrific::ParamSet: #{ filterrific_param_set.inspect }"
        )
      end

      # Initialize ActiveRecord::Relation
      ar_rel = if ActiveRecord::Relation === self
        # self is already an ActiveRecord::Relation, use as is
        self
      elsif Rails::VERSION::MAJOR <= 3
        # Active Record 3: send `:scoped` to class to get an ActiveRecord::Relation
        scoped
      else
        # Active Record 4 and later: Send `:all` to class to get an ActiveRecord::Relation
        all
      end

      # Apply filterrific params
      filterrific_available_filters.each do |filter_name|
        filter_param = filterrific_param_set.send(filter_name)
        next if filter_param.blank? # skip blank filter_params
        ar_rel = ar_rel.send(filter_name, filter_param)
      end

      ar_rel
    end

  protected

    # Defines a :sorted_by scope based on attrs
    # @param attrs [Hash] with keys as
    # def define_sorted_by_scope(attrs)
    #   scope :sorted_by, lambda {}
    # end

    # Assigns available filters.
    # @param opts [Hash] the complete options hash passed to `filterrific`.
    #   This method uses the 'available_filters', 'sorted_by', and 'search_query' keys.
    # @return [void]
    def assign_filterrific_available_filters(opts)
      self.filterrific_available_filters = (
        filterrific_available_filters + (opts['available_filters'] || [])
      ).map(&:to_s).uniq.sort
    end

    # Validates presence of at least one available filter.
    # @return [void]
    def validate_filterrific_available_filters
      if filterrific_available_filters.blank?
        raise(ArgumentError, ":available_filters can't be empty")
      end
    end

    def assign_filterrific_default_filter_params(opts)
      self.filterrific_default_filter_params = (
        opts['default_filter_params'] || {}
      ).stringify_keys
    end

    def validate_filterrific_default_filter_params
      # Raise exception if defaults contain keys that are not present in available_filters
      if (
        inv_fdfps = filterrific_default_filter_params.keys - filterrific_available_filters
      ).any?
        raise(ArgumentError, "Invalid default filter params: #{ inv_fdfps.inspect }")
      end
    end

  end
end
