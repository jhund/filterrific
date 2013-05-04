module Filterrific::ViewHelpers

  # Renders a spinner while the list is being updated
  def render_filterrific_spinner
    %(
      <span class="filterrific_spinner" style="display:none;">
        #{ image_tag('filterrific-spinner.gif') }
      </span>
    ).html_safe
  end

end
