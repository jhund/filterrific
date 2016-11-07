require 'spec_helper'
require 'active_record'
require 'filterrific/active_record_extension'

ActiveRecord::Base.extend Filterrific::ActiveRecordExtension

module Filterrific

  describe ActiveRecordExtension do

    # Container for test data
    class TestDataARES

      def self.filterrific_available_filters
        %w[search_query sorted_by with_country_id]
      end

      def self.filterrific_default_filter_params
        { 'sorted_by' => 'name_asc' }
      end

    end

    let(:filterrific_class){
      Class.new(ActiveRecord::Base) do
        filterrific(
          available_filters: TestDataARES.filterrific_available_filters,
          default_filter_params: TestDataARES.filterrific_default_filter_params
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
          TestDataARES.filterrific_available_filters
        )
      end

      it "initializes filterrific_default_filter_params" do
        filterrific_class.filterrific_default_filter_params.must_equal(
          TestDataARES.filterrific_default_filter_params
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

  describe "Single Table Inheritance" do

    class Daddy < ActiveRecord::Base
      filterrific(available_filters: [:one, :two])
    end

    class Girl < Daddy
      filterrific(available_filters: [:three, :four])
    end

    %w(one two).each do |value|
      it { Daddy.filterrific_available_filters.must_include value }
    end

    %w(three four).each do |value|
      it { Girl.filterrific_available_filters.must_include value }
    end

  end

end
