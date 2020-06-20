require 'spec_helper'
require 'filterrific/action_view_extension'

module Filterrific

  describe ActionViewExtension do

    class ViewContext
      include ActionViewExtension
    end

    it 'responds to #form_for_filterrific' do
      _(ViewContext.new).must_respond_to(:form_for_filterrific)
    end

    it 'responds to #render_filterrific_spinner' do
      _(ViewContext.new).must_respond_to(:render_filterrific_spinner)
    end

    it 'responds to #filterrific_sorting_link' do
      _(ViewContext.new).must_respond_to(:filterrific_sorting_link)
    end

    it 'responds to #reset_filterrific_url' do
      _(ViewContext.new).must_respond_to(:reset_filterrific_url)
    end

  end
end
