require 'spec_helper'
require 'filterrific/param_set'

module Filterrific

  # Container for test data
  class TestData

    def self.filterrific_filter_names
      %w[
        filter_proc
        filter_array_int
        filter_array_string
        filter_int
        filter_string
      ]
    end

    def self.filterrific_default_settings
      { 'filter_int' => 42 }
    end

    def self.filterrific_params
      {
        'filter_proc' => lambda { 1 + 1 },
        'filter_array_int' => %w[1 2 3],
        'filter_array_string' => %w[one two three],
        'filter_int' => '42',
        'filter_string' => 'forty-two'
      }
    end

    def self.filterrific_params_after_sanitizing
      {
        'filter_proc' => 2,
        'filter_array_int' => [1, 2, 3],
        'filter_array_string' => %w[one two three],
        'filter_int' => 42,
        'filter_string' => 'forty-two'
      }
    end

  end

  # Simulates a class that would include the filterrific directive
  class ResourceClass

    def self.filterrific_default_settings
      TestData.filterrific_default_settings
    end
    def self.filterrific_filter_names
      TestData.filterrific_filter_names
    end

  end

  describe ParamSet do

    let(:filterrific_param_set){
      Filterrific::ParamSet.new(ResourceClass, TestData.filterrific_params)
    }

    describe "initialization" do

      it "assigns resource class" do
        filterrific_param_set.resource_class.must_equal(ResourceClass)
      end

      describe "dynamic filter_name attr_accessors" do

        TestData.filterrific_filter_names.each do |filter_name|

          it "defines a getter for '#{ filter_name }'" do
            filterrific_param_set.must_respond_to(filter_name)
          end

          it "defines a setter for '#{ filter_name }'" do
            filterrific_param_set.must_respond_to("#{ filter_name }=")
          end

        end

        TestData.filterrific_params.keys.each do |key|

          it "assigns sanitized param to '#{ key }' attr" do
            filterrific_param_set.send(key).must_equal(TestData.filterrific_params_after_sanitizing[key])
          end

        end

      end

    end

    describe "to_hash" do

      it "returns all filterrific_params as hash" do
        filterrific_param_set.to_hash.must_equal(TestData.filterrific_params_after_sanitizing)
      end

    end

    describe "to_json" do

      it "returns all filterrific_params as json string" do
        filterrific_param_set.to_json.must_equal(TestData.filterrific_params_after_sanitizing.to_json)
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

  end
end
