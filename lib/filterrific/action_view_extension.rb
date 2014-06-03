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
        #{ image_tag('filterrific-spinner.gif') }
      </span>
    ).html_safe
  end

end
