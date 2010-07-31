module Filterrific::ViewHelpers

  # renders javascript to observe filter form
  def observe_list_options_filter(options = {})
    # default options
    options = {
      :form_id => 'list_options_filter',
      :method => :get,
      :live_field_ids => [],
      :url => url_for(:controller => controller.controller_path, :action => controller.action_name)
    }.merge(options)
    # observe the entire form regularly (triggers e.g. when a select option is clicked)
    # observe_form(
    #   options[:form_id],
    #   :function => observer_ajax_javascript(options, 'value'),
    #   :frequency => 0.5
    # )
  end

  def render_list_options_spinner
    %(<span id="list_options_spinner" class="spinner" style="display:none;"> </span>)
  end

private

  def observer_ajax_javascript(options, parameters_to_be_submitted)
    # options = {
    #   :with => parameters_to_be_submitted,
    #   :loading => "$('#list_options_spinner').show()",
    #   :complete => "$('#list_options_spinner').hide()"
    # }.merge(options)
    # remote_function(options)
  end

end
