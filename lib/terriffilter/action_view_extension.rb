# -*- coding: utf-8 -*-
#
# Adds terriffilter view helpers to ActionView instances
#
module Terriffilter
  module ActionViewExtension

    include HasResetTerriffilterUrlMixin

    # Sets all options on form_for to defaults that work with terriffilter
    # @param record [terriffilter] the @terriffilter object
    # @param options [Hash] standard options for form_for
    # @param block [Proc] the form body
    def form_for_terriffilter(record, options = {}, &block)
      options[:as] ||= :terriffilter
      options[:html] ||= {}
      options[:html][:method] ||= :get
      options[:html][:id] ||= :terriffilter_filter
      options[:url] ||= url_for(
        :controller => controller.controller_name,
        :action => controller.action_name
      )
      form_for(record, options, &block)
    end

    # Renders a spinner while the list is being updated
    def render_terriffilter_spinner
      %(
        <span class="terriffilter_spinner" style="display:none;">
          #{ image_tag('terriffilter/terriffilter-spinner.gif') }
        </span>
      ).html_safe
    end

    # Renders a link which indicates the current sorting and which can be used to
    # toggle the list sorting (set column and direction).
    #
    # NOTE: Make sure that this is used in the list partial that is re-rendered
    # when the terriffilter params are changed, so that the terriffilter params in
    # the URL are always current.
    #
    # NOTE: Currently the terriffilter_sorting_link is not synchronized with a
    # SELECT input you may have in the filter form for sorting. We recommend you
    # use one or the other to avoid conflicting sort settings in the UI.
    #
    # @param terriffilter [terriffilter::ParamSet] the current terriffilter instance
    # @param sort_key [String, Symbol] the key to sort by, without direction.
    #     Example: 'name', 'created_at'
    # @param opts [Hash, optional]
    # @options opts [String, optional] active_column_class
    #     CSS class applied to current sort column. Default: 'terriffilter_current_sort_column'
    # @options opts [String, optional] ascending_indicator
    #     HTML string to indicate ascending sort direction. Default: '⬆'
    # @options opts [String, optional] default_sort_direction
    #     Override the default sorting when selecting a new sort column. Default: 'asc'.
    # @options opts [String, optional] descending_indicator
    #     HTML string to indicate descending sort direction. Default: '⬇'
    # @options opts [Hash, optional] html_attrs
    #     HTML attributes to be added to the sorting link. Default: {}
    # @options opts [String, optional] label
    #     Override label. Default: `sort_key.to_s.humanize`.
    # @options opts [String, Symbol, optional] sorting_scope_name
    #     Override the name of the scope used for sorting. Default: :sorted_by
    # @options opts [Hash, optional] url_for_attrs
    #     Override the target URL attributes to be used for `url_for`. Default: {} (current URL).
    def terriffilter_sorting_link(terriffilter, sort_key, opts = {})
      opts = {
        :active_column_class => 'terriffilter_current_sort_column',
        :inactive_column_class => 'terriffilter_sort_column',
        :ascending_indicator => '⬆',
        :default_sort_direction => 'asc',
        :descending_indicator => '⬇',
        :html_attrs => {},
        :label => sort_key.to_s.humanize,
        :sorting_scope_name => :sorted_by,
        :url_for_attrs => {},
      }.merge(opts)
      opts.merge!(
        :html_attrs => opts[:html_attrs].with_indifferent_access,
        :current_sorting => (current_sorting = terriffilter.send(opts[:sorting_scope_name])),
        :current_sort_key => current_sorting ? current_sorting.gsub(/_asc|_desc/, '') : nil,
        :current_sort_direction => current_sorting ? (current_sorting =~ /_desc\z/ ? 'desc' : 'asc') : nil,
        :current_sort_direction_indicator => (current_sorting =~ /_desc\z/ ? opts[:descending_indicator] : opts[:ascending_indicator]),
      )
      new_sort_key = sort_key.to_s
      if new_sort_key == opts[:current_sort_key]
        # same sort column, reverse order
        terriffilter_sorting_link_reverse_order(terriffilter, new_sort_key, opts)
      else
        # new sort column, default sort order
        terriffilter_sorting_link_new_column(terriffilter, new_sort_key, opts)
      end
    end

  protected

    # Renders HTML to reverse sort order on currently sorted column.
    # @param terriffilter [terriffilter::ParamSet]
    # @param new_sort_key [String]
    # @param opts [Hash]
    # @return [String] an HTML fragment
    def terriffilter_sorting_link_reverse_order(terriffilter, new_sort_key, opts)
      # current sort column, toggle search_direction
      new_sort_direction = 'asc' == opts[:current_sort_direction] ? 'desc' : 'asc'
      new_sorting = safe_join([new_sort_key, new_sort_direction], '_')
      css_classes = safe_join([
        opts[:active_column_class],
        opts[:html_attrs].delete(:class)
      ].compact, ' ')
      new_terriffilter_params = terriffilter.to_hash
                                          .with_indifferent_access
                                          .merge(opts[:sorting_scope_name] => new_sorting)
      url_for_attrs = opts[:url_for_attrs].merge(:terriffilter => new_terriffilter_params)
      link_to(
        safe_join([opts[:label], opts[:current_sort_direction_indicator]], ' '),
        url_for(url_for_attrs),
        opts[:html_attrs].reverse_merge(:class => css_classes, :method => :get, :remote => true)
      )
    end

    # Renders HTML to sort by a new column.
    # @param terriffilter [terriffilter::ParamSet]
    # @param new_sort_key [String]
    # @param opts [Hash]
    # @return [String] an HTML fragment
    def terriffilter_sorting_link_new_column(terriffilter, new_sort_key, opts)
      new_sort_direction = opts[:default_sort_direction]
      new_sorting = safe_join([new_sort_key, new_sort_direction], '_')
      css_classes = safe_join([
        opts[:inactive_column_class],
        opts[:html_attrs].delete(:class)
      ].compact, ' ')
      new_terriffilter_params = terriffilter.to_hash
                                          .with_indifferent_access
                                          .merge(opts[:sorting_scope_name] => new_sorting)
      url_for_attrs = opts[:url_for_attrs].merge(:terriffilter => new_terriffilter_params)
      link_to(
        opts[:label],
        url_for(url_for_attrs),
        opts[:html_attrs].reverse_merge(:class => css_classes, :method => :get, :remote => true)
      )
    end

  end
end
