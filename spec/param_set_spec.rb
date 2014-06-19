require 'spec_helper'
require 'filterrific/param_set'

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

describe Filterrific::ParamSet do

  let(:filterrific_param_set){
    Filterrific::ParamSet.new(ResourceClass, TestData.filterrific_params)
  }

  describe "initialization" do

    it "assigns resource class" do
      filterrific_param_set.resource_class.should == ResourceClass
    end

    describe "dynamic filter_name attr_accessors" do

      TestData.filterrific_filter_names.each do |filter_name|

        it "defines a getter for '#{ filter_name }'" do
          filterrific_param_set.should respond_to(filter_name)
        end

        it "defines a setter for '#{ filter_name }'" do
          filterrific_param_set.should respond_to("#{ filter_name }=")
        end

      end

      TestData.filterrific_params.keys.each do |key|

        it "assigns sanitized param to '#{ key }' attr" do
          filterrific_param_set.send(key).should == TestData.filterrific_params_after_sanitizing[key]
        end

      end

    end

  end

  describe "to_hash" do

    it "returns all filterrific_params as hash" do
      filterrific_param_set.to_hash.should == TestData.filterrific_params_after_sanitizing
    end

  end

  describe "to_json" do

    it "returns all filterrific_params as json string" do
      filterrific_param_set.to_json.should == TestData.filterrific_params_after_sanitizing.to_json
    end

  end

  describe "#select_options" do
    it "exists" do
      expect(filterrific_param_set.select_options).to eq({})
    end

    it "lets you assign a hash" do
      expect{filterrific_param_set.select_options = {}}.not_to raise_error
    end

    it "lets you set a value" do
      expect{filterrific_param_set.select_options[:value] = 1}.not_to raise_error
    end

    it "returns the same value you set" do
      value = rand(1..200)
      filterrific_param_set.select_options[:value] = value
      expect(filterrific_param_set.select_options[:value]).to eq(value)
    end
  end

end
