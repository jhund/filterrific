require 'spec_helper'
require 'active_record'
require 'filterrific/active_record_extension'

ActiveRecord::Base.extend Filterrific::ActiveRecordExtension

module Filterrific

  # Container for test data
  class TestData

    def self.filterrific_available_filters
      %w[search_query sorted_by with_country_id]
    end

    def self.filterrific_default_filter_params
      { 'sorted_by' => 'name_asc' }
    end

  end

  describe ActiveRecordExtension do

    let(:filterrific_class){
      Class.new(ActiveRecord::Base) do
        filterrific(
          available_filters: TestData.filterrific_available_filters,
          default_filter_params: TestData.filterrific_default_filter_params
        )
      end
    }

    describe "Class method extensions" do

      it "adds a 'filterrific' class method" do
        filterrific_class.must_respond_to(:filterrific)
      end

      it "adds a 'filterrific_find' class method" do
        filterrific_class.must_respond_to(:filterrific_find)
      end

    end

    describe "Filterrific initialization" do

      it "initializes filterrific_available_filters" do
        filterrific_class.filterrific_available_filters.must_equal(
          TestData.filterrific_available_filters
        )
      end

      it "initializes filterrific_default_filter_params" do
        filterrific_class.filterrific_default_filter_params.must_equal(
          TestData.filterrific_default_filter_params
        )
      end

      it "raises when no available_filters are given" do
        proc {
          Class.new(ActiveRecord::Base) do
            filterrific(
              available_filters: []
            )
          end
        }.must_raise(ArgumentError)
      end

      it "raises when default_settings contains keys that are not in available_filters" do
        proc {
          Class.new(ActiveRecord::Base) do
            filterrific(
              available_filters: [:one, :two],
              default_filter_params:{ three: '' }
            )
          end
        }.must_raise(ArgumentError)
      end

    end

    describe "filterrific_find" do

      it "raises when given invalid params" do
        proc {
          filterrific_class.filterrific_find('an invalid argument')
        }.must_raise(ArgumentError)
      end

    end

  end
end
