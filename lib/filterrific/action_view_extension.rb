# -*- coding: utf-8 -*-

#
# Adds view helpers to ActionView
#
module Filterrific::ActionViewExtension

  # Sets all options on form_for to defaults if called with Filterrific object
  def form_for(record, options = {}, &block)
    if record.is_a?(Filterrific::ParamSet)
      options[:as] ||= :filterrific
      options[:html] ||= {}
      options[:html][:method] ||= :get
      options[:html][:id] ||= :filterrific_filter
      options[:url] ||= url_for(:controller => controller.controller_name, :action => controller.action_name)
    end
    super
  end

  # Renders a spinner while the list is being updated
  def render_filterrific_spinner
    %(
      <span class="filterrific_spinner" style="display:none;">
        #{ image_tag('filterrific/filterrific-spinner.gif') }
      </span>
    ).html_safe
  end

  # Renders a link which indicates the current sorting and which can be used to
  # toggle the list sorting (set column and direction).
  # NOTE: Make sure that this is used in the list partial that is re-rendered
  # when the filterrific params are changed, so that the filterrific params in
  # the URL are always current.
  # @param[Filterrific::ParamSet] filterrific the current filterrific instance
  # @param[String, Symbol] sort_key the key to sort by, without direction.
  #     Example: 'name', 'created_at'
  # @param[Hash, optional] options:
  #     * active_column_class: CSS class applied to current sort column.
  #       Default: 'filterrific_current_sort_column'
  #     * ascending_indicator: HTML string to indicate ascending sort direction.
  #       Default: Triangle pointing up.
  #     * default_sort_direction: override the default sorting when selecting
  #       a new sort column. Default: 'asc'.
  #     * descending_indicator: HTML string to indicate descending sort direction.
  #       Default: Triangle pointing down.
  #     * html_attrs: HTML attributes to be added to the sorting link. Default: {}
  #     * label: override label. Default: `sort_key.humanize`.
  #     * sorting_scope_name: override the name of the scope used for sorting.
  #       Default: `:sorted_by`
  #     * url_for_attrs: override the target URL attributes to be used for `url_for`.
  #       Default: {} (current URL).
  def filterrific_sorting_link(filterrific, sort_key, options = {})
    options = {
      :active_column_class => 'filterrific_current_sort_column',
      :ascending_indicator => '⬆',
      :default_sort_direction => 'asc',
      :descending_indicator => '⬇',
      :html_attrs => {},
      :label => sort_key.to_s.humanize,
      :sorting_scope_name => :sorted_by,
      :url_for_attrs => {},
    }.merge(options)
    options[:html_attrs] = options[:html_attrs].with_indifferent_access
    current_sorting = filterrific.send(options[:sorting_scope_name])
    current_sort_key = current_sorting ? current_sorting.gsub(/_asc|_desc/, '') : nil
    current_sort_direction = current_sorting ? (current_sorting =~ /_desc\z/ ? 'desc' : 'asc') : nil
    new_sort_key = sort_key.to_s
    if new_sort_key == current_sort_key
      # current sort column, toggle search_direction
      new_sort_direction, current_sort_direction_indicator = if 'asc' == current_sort_direction
        ['desc', options[:ascending_indicator]]
      else
        ['asc', options[:descending_indicator]]
      end
      new_sorting = [new_sort_key, new_sort_direction].join('_')
      css_classes = [
        options[:active_column_class],
        options[:html_attrs].delete(:class)
      ].compact.join(' ')
      new_filterrific_params = filterrific.to_hash
                                          .with_indifferent_access
                                          .merge(options[:sorting_scope_name] => new_sorting)
      url_for_attrs = options[:url_for_attrs].merge(:filterrific => new_filterrific_params)
      link_to(
        [options[:label], current_sort_direction_indicator].join(' '),
        url_for(url_for_attrs),
        options[:html_attrs].reverse_merge(:class => css_classes, :method => :get, :remote => true)
      )
    else
      # new sort column, change sort column
      new_sort_direction = options[:default_sort_direction]
      new_sorting = [new_sort_key, new_sort_direction].join('_')
      new_filterrific_params = filterrific.to_hash
                                          .with_indifferent_access
                                          .merge(options[:sorting_scope_name] => new_sorting)
      url_for_attrs = options[:url_for_attrs].merge(:filterrific => new_filterrific_params)
      link_to(
        options[:label],
        url_for(url_for_attrs),
        options[:html_attrs].reverse_merge(:method => :get, :remote => true)
      )
    end
  end

end
