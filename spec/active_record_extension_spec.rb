require 'spec_helper'
require 'active_record'
require 'filterrific/active_record_extension'
::ActiveRecord::Base.extend Filterrific::ActiveRecordExtension::ClassMethods

# Container for test data
class TestData

  def self.filterrific_filter_names
    %w[sorted_by search_query with_country_id]
  end

  def self.filterrific_default_settings
    { 'sorted_by' => 'name_asc' }
  end

end

describe Filterrific::ActiveRecordExtension do

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
      filterrific_class.should respond_to(:filterrific)
    end

    it "adds a 'filterrific_find' class method" do
      filterrific_class.should respond_to(:filterrific_find)
    end

  end

  describe "Filterrific initialization" do

    it "initializes filterrific_filter_names" do
      filterrific_class.filterrific_filter_names.should == TestData.filterrific_filter_names
    end

    it "initializes filterrific_default_settings" do
      filterrific_class.filterrific_default_settings.should == TestData.filterrific_default_settings
    end

    it "raises when no filter_names are given" do
      expect {
        Class.new(ActiveRecord::Base) do
          filterrific(
            :filter_names => []
          )
        end
      }.to raise_error(ArgumentError)
    end

    it "raises when default_settings contains keys that are not in filter_names" do
      expect {
        Class.new(ActiveRecord::Base) do
          filterrific(
            :filter_names => [:one, :two],
            :default_settings => { :three => '' }
          )
        end
      }.to raise_error(ArgumentError)
    end

  end

  describe "filterrific_find" do

    it "raises when given invalid params" do
      expect {
        filterrific_class.filterrific_find('an invalid argument')
      }.to raise_error(ArgumentError)
    end

  end

end
