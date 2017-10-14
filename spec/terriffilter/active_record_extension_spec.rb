require 'spec_helper'
require 'active_record'
require 'terriffilter/active_record_extension'

ActiveRecord::Base.extend Terriffilter::ActiveRecordExtension

module Terriffilter

  describe ActiveRecordExtension do

    # Container for test data
    class TestDataARES

      def self.terriffilter_available_filters
        %w[search_query sorted_by with_country_id]
      end

      def self.terriffilter_default_filter_params
        { 'sorted_by' => 'name_asc' }
      end

    end

    let(:terriffilter_class){
      Class.new(ActiveRecord::Base) do
        terriffilter(
          available_filters: TestDataARES.terriffilter_available_filters,
          default_filter_params: TestDataARES.terriffilter_default_filter_params
        )
      end
    }

    describe "Class method extensions" do

      it "adds a 'terriffilter' class method" do
        terriffilter_class.must_respond_to(:terriffilter)
      end

      it "adds a 'terriffilter_find' class method" do
        terriffilter_class.must_respond_to(:terriffilter_find)
      end

    end

    describe "terriffilter initialization" do

      it "initializes terriffilter_available_filters" do
        terriffilter_class.terriffilter_available_filters.must_equal(
          TestDataARES.terriffilter_available_filters
        )
      end

      it "initializes terriffilter_default_filter_params" do
        terriffilter_class.terriffilter_default_filter_params.must_equal(
          TestDataARES.terriffilter_default_filter_params
        )
      end

      it "raises when no available_filters are given" do
        proc {
          Class.new(ActiveRecord::Base) do
            terriffilter(
              available_filters: []
            )
          end
        }.must_raise(ArgumentError)
      end

      it "raises when default_settings contains keys that are not in available_filters" do
        proc {
          Class.new(ActiveRecord::Base) do
            terriffilter(
              available_filters: [:one, :two],
              default_filter_params:{ three: '' }
            )
          end
        }.must_raise(ArgumentError)
      end

    end

    describe "terriffilter_find" do

      it "raises when given invalid params" do
        proc {
          terriffilter_class.terriffilter_find('an invalid argument')
        }.must_raise(ArgumentError)
      end

    end

  end

  describe "Single Table Inheritance" do

    class Daddy < ActiveRecord::Base
      terriffilter(available_filters: [:one, :two])
    end

    class Girl < Daddy
      terriffilter(available_filters: [:three, :four])
    end

    %w(one two).each do |value|
      it { Daddy.terriffilter_available_filters.must_include value }
    end

    %w(three four).each do |value|
      it { Girl.terriffilter_available_filters.must_include value }
    end

  end

end
