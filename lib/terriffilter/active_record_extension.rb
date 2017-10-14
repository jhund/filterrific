# -*- coding: utf-8 -*-
#
# Adds terriffilter methods to ActiveRecord::Base model_class.
#
require 'terriffilter/param_set'

module Terriffilter
  module ActiveRecordExtension

    # Adds terriffilter behavior to class when called like so:
    #
    # terriffilter(
    #   :available_filters => [:sorted_by, :search_query, :with_state]
    #   :default_filter_params => { :sorted_by => "created_at_asc" },
    # )
    #
    # @params opts [Hash] with either string or symbol keys, will be stringified.
    # @option opts [Array<String, Symbol>] available_filters: a list of filters to be exposed by terriffilter.
    # @option opts [Hash, optional] default_filter_params: default filter parameters
    # @return [void]
    def terriffilter(opts)
      class << self
        attr_accessor :terriffilter_available_filters
        attr_accessor :terriffilter_default_filter_params
      end
      self.terriffilter_available_filters = []

      opts.stringify_keys!

      # define_sorted_by_scope(opts['sorted_by'])  if opts['sorted_by']
      # define_search_query_scope(opts['search_query'])  if opts['search_query']

      assign_terriffilter_available_filters(opts)
      validate_terriffilter_available_filters
      assign_terriffilter_default_filter_params(opts)
      validate_terriffilter_default_filter_params

    end

    # Returns ActiveRecord relation based on terriffilter_param_set.
    # Use like so: `ModelClass.terriffilter_find(@terriffilter)`
    #
    # @param terriffilter_param_set [terriffilter::ParamSet]
    # @return [ActiveRecord::Relation] with filters applied
    def terriffilter_find(terriffilter_param_set)
      unless terriffilter_param_set.is_a?(terriffilter::ParamSet)
        raise(
          ArgumentError,
          "Invalid terriffilter::ParamSet: #{ terriffilter_param_set.inspect }"
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

      # Apply terriffilter params
      terriffilter_available_filters.each do |filter_name|
        filter_param = terriffilter_param_set.send(filter_name)
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
    # @param opts [Hash] the complete options hash passed to `terriffilter`.
    #   This method uses the 'available_filters', 'sorted_by', and 'search_query' keys.
    # @return [void]
    def assign_terriffilter_available_filters(opts)
      self.terriffilter_available_filters = (
        terriffilter_available_filters + (opts['available_filters'] || [])
      ).map(&:to_s).uniq.sort
    end

    # Validates presence of at least one available filter.
    # @return [void]
    def validate_terriffilter_available_filters
      if terriffilter_available_filters.blank?
        raise(ArgumentError, ":available_filters can't be empty")
      end
    end

    def assign_terriffilter_default_filter_params(opts)
      self.terriffilter_default_filter_params = (
        opts['default_filter_params'] || {}
      ).stringify_keys
    end

    def validate_terriffilter_default_filter_params
      # Raise exception if defaults contain keys that are not present in available_filters
      if (
        inv_fdfps = terriffilter_default_filter_params.keys - terriffilter_available_filters
      ).any?
        raise(ArgumentError, "Invalid default filter params: #{ inv_fdfps.inspect }")
      end
    end

  end
end
