require 'spec_helper'
require 'filterrific/param_set'

module Filterrific

  describe ParamSet do

    # Container for test data
    class TestData

      def self.filterrific_available_filters
        %w[
          filter_almost_int
          filter_array_int
          filter_array_string
          filter_hash
          filter_hyphen
          filter_int
          filter_negative_int
          filter_proc
          filter_string
          filter_zero
        ]
      end

      def self.filterrific_default_filter_params
        { 'filter_int' => 42 }
      end

      def self.filterrific_params
        {
          'filter_almost_int' => '042',
          'filter_array_int' => %w[1 2 3],
          'filter_array_string' => %w[one two three],
          'filter_hash' => { a: 1, b: 2 },
          'filter_hyphen' => '-',
          'filter_int' => '42',
          'filter_negative_int' => '-42',
          'filter_proc' => lambda { 1 + 1 },
          'filter_string' => 'forty-two',
          'filter_zero' => '0',
        }
      end

      def self.filterrific_params_after_conditioning
        {
          'filter_almost_int' => '042',
          'filter_array_int' => [1, 2, 3],
          'filter_array_string' => %w[one two three],
          'filter_hash' => OpenStruct.new(a: 1, b: 2),
          'filter_hyphen' => '-',
          'filter_int' => 42,
          'filter_negative_int' => -42,
          'filter_proc' => 2,
          'filter_string' => 'forty-two',
          'filter_zero' => 0,
        }
      end

      def self.filterrific_params_as_hash
        {
          'filter_almost_int' => '042',
          'filter_array_int' => [1, 2, 3],
          'filter_array_string' => %w[one two three],
          'filter_hash' => { a: 1, b: 2 },
          'filter_hyphen' => '-',
          'filter_int' => 42,
          'filter_negative_int' => -42,
          'filter_proc' => 2,
          'filter_string' => 'forty-two',
          'filter_zero' => 0,
        }
      end

    end

    # Simulates a class that would include the filterrific directive
    class ModelClass

      def self.filterrific_default_filter_params
        TestData.filterrific_default_filter_params
      end
      def self.filterrific_available_filters
        TestData.filterrific_available_filters
      end

    end

    let(:filterrific_param_set){
      Kernel::silence_warnings {
        Filterrific::ParamSet.new(ModelClass, TestData.filterrific_params)
      }
    }

    describe "initialization" do

      it "assigns resource class" do
        filterrific_param_set.model_class.must_equal(ModelClass)
      end

      describe "dynamic filter_name attr_accessors" do

        TestData.filterrific_available_filters.each do |filter_name|

          it "defines a getter for '#{ filter_name }'" do
            filterrific_param_set.must_respond_to(filter_name)
          end

          it "defines a setter for '#{ filter_name }'" do
            filterrific_param_set.must_respond_to("#{ filter_name }=")
          end

        end

        TestData.filterrific_params.keys.each do |key|

          it "assigns conditioned param to '#{ key }' attr" do
            filterrific_param_set.send(key).must_equal(TestData.filterrific_params_after_conditioning[key])
          end

        end

      end

    end

    describe 'find' do
      it 'responds to #find' do
        filterrific_param_set.must_respond_to(:find)
      end
    end

    describe "to_hash" do

      it "returns all filterrific_params as hash" do
        filterrific_param_set.to_hash.must_equal(
          TestData.filterrific_params_as_hash
        )
      end

    end

    describe "to_json" do

      it "returns all filterrific_params as json string" do
        filterrific_param_set.to_json.must_equal(
          TestData.filterrific_params_as_hash.to_json
        )
      end

    end

    describe "#select_options" do
      it "exists" do
        filterrific_param_set.select_options.must_equal({})
      end

      it "lets you assign a hash" do
        # Make sure it doesn't raise an exception
        filterrific_param_set.select_options = {}
        1.must_equal(1)
      end

      it "lets you set a value" do
        # Make sure it doesn't raise an exception
        filterrific_param_set.select_options[:value] = 1
        1.must_equal(1)
      end

      it "returns the same value you set" do
        value = rand(1..200)
        filterrific_param_set.select_options[:value] = value
        filterrific_param_set.select_options[:value].must_equal(value)
      end
    end

    describe "#condition_filterrific_params" do

      [
        [{ a_proc: lambda { 1 + 1 } }, { a_proc: 2 }],
        [{ an_array: [1, 'a'] }, { an_array: [1, 'a'] }],
        [{ a_hash: { 'a' => 1, 'b' => 2 } }, { a_hash: OpenStruct.new({ 'a' => 1, 'b' => 2 }) }],
        [{ a_string_that_looks_like_int: '123' }, { a_string_that_looks_like_int: 123 }],
        [{ a_string_that_looks_like_a_negative_int: '-123' }, { a_string_that_looks_like_a_negative_int: -123 }],
        [{ a_string_that_almost_looks_like_int: '0123' }, { a_string_that_almost_looks_like_int: '0123' }],
        [{ an_array_with_almost_int: ['0123', '123'] }, { an_array_with_almost_int: ['0123', 123] }],
        [{ a_string: 'abc' }, { a_string: 'abc' }],
      ].each do |test_params, xpect|
        it "Handles #{ test_params.inspect }" do
          filterrific_param_set.send(
            :condition_filterrific_params,
            test_params
          ).must_equal(xpect)
        end
      end

    end

  end
end
