require 'spec_helper'
require 'filterrific/action_view_extension'

class ViewContext

  include Filterrific::ActionViewExtension

end

describe Filterrific::ActionViewExtension do

  it "renders filterrific spinner" do
    ViewContext.new.should respond_to(:render_filterrific_spinner)
  end

end
