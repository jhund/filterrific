require 'spec_helper'
require 'filterrific/action_view_extension'

module Filterrific

  class ViewContext
    include ActionViewExtension
  end

  describe ActionViewExtension do

    describe '#render_filterrific_spinner' do
      it "renders filterrific spinner" do
        ViewContext.new.must_respond_to(:render_filterrific_spinner)
      end
    end

    describe '#filterrific_sorting_link' do
      it 'changes sorting on new column' do
      end
    end

  end
end
