require 'spec_helper'
require 'terriffilter/action_view_extension'

module Terriffilter

  describe ActionViewExtension do

    class ViewContext
      include ActionViewExtension
    end

    it 'responds to #form_for_terriffilter' do
      ViewContext.new.must_respond_to(:form_for_terriffilter)
    end

    it 'responds to #render_terriffilter_spinner' do
      ViewContext.new.must_respond_to(:render_terriffilter_spinner)
    end

    it 'responds to #terriffilter_sorting_link' do
      ViewContext.new.must_respond_to(:terriffilter_sorting_link)
    end

    it 'responds to #reset_terriffilter_url' do
      ViewContext.new.must_respond_to(:reset_terriffilter_url)
    end

  end
end
