require 'spec_helper'
require 'active_record'
require 'filterrific/active_record_extension'

ActiveRecord::Base.extend Filterrific::ActiveRecordExtension

module Filterrific

  # Container for test data
  class TestData

    def self.filterrific_filter_names
      %w[sorted_by search_query with_country_id]
    end

    def self.filterrific_default_settings
      { 'sorted_by' => 'name_asc' }
    end

  end

  describe ActiveRecordExtension do

    let(:filterrific_class){
      Class.new(ActiveRecord::Base) do
        filterrific(
          :filter_names => TestData.filterrific_filter_names,
          :default_settings => TestData.filterrific_default_settings
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

      it "initializes filterrific_filter_names" do
        filterrific_class.filterrific_filter_names.must_equal(TestData.filterrific_filter_names)
      end

      it "initializes filterrific_default_settings" do
        filterrific_class.filterrific_default_settings.must_equal(TestData.filterrific_default_settings)
      end

      it "raises when no filter_names are given" do
        proc {
          Class.new(ActiveRecord::Base) do
            filterrific(
              :filter_names => []
            )
          end
        }.must_raise(ArgumentError)
      end

      it "raises when default_settings contains keys that are not in filter_names" do
        proc {
          Class.new(ActiveRecord::Base) do
            filterrific(
              :filter_names => [:one, :two],
              :default_settings => { :three => '' }
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
