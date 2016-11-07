require 'spec_helper'
require 'filterrific/action_controller_extension'

module Filterrific

  describe ActionControllerExtension do

    class TestController
      include ActionControllerExtension
      def action_name; 'index'; end
      def controller_name; 'test_controller'; end
      def session
        {
          'test_controller#index' => {
            'filter1' => '1_from_session',
            'filter2' => '2_from_session',
          }
        }
      end
    end

    class TestModelClass
      def self.filterrific_available_filters; %w[filter1 filter2]; end
      def self.filterrific_default_filter_params
        { 'filter1' => '1_from_model_defaults' }
      end
    end

    describe '#initialize_filterrific' do

      it 'returns a Filterrific::ParamSet' do
        TestController.new.send(
          :initialize_filterrific,
          TestModelClass,
          { 'filter1' => 1, 'filter2' => 2 },
        ).must_be_instance_of(ParamSet)
      end

    end

    describe '#compute_default_persistence_id' do

      it 'computes the default persistence id from controller_name and action_name' do
        TestController.new.send(
          :compute_default_persistence_id
        ).must_equal('test_controller#index')
      end

    end

    describe '#compute_filterrific_params' do

      it 'uses filterrific_params if given' do
        TestController.new.send(
          :compute_filterrific_params,
          TestModelClass,
          { 'filter1' => 1, 'filter2' => 2 },
          { },
          'test_controller#index'
        ).must_equal({ 'filter1' => 1, 'filter2' => 2 })
      end

      it 'uses session if filterrific_params are blank' do
        TestController.new.send(
          :compute_filterrific_params,
          TestModelClass,
          {},
          { },
          'test_controller#index',
        ).must_equal({ 'filter1' => '1_from_session', 'filter2' => '2_from_session' })
      end

      it "uses opts['default_filter_params'] if session is blank" do
        TestController.new.send(
          :compute_filterrific_params,
          TestModelClass,
          {},
          { 'default_filter_params' => { 'filter1' => '1_from_opts' } },
          'non existent persistence id to skip session',
        ).must_equal({ 'filter1' => '1_from_opts' })
      end

      it "uses model default_filter_params if opts is blank" do
        TestController.new.send(
          :compute_filterrific_params,
          TestModelClass,
          {},
          { },
          'non existent persistence id to skip session',
        ).must_equal({ 'filter1' => '1_from_model_defaults' })
      end

      it "limits filter params to opts['available_filters']" do
        TestController.new.send(
          :compute_filterrific_params,
          TestModelClass,
          { 'filter1' => 1, 'filter2' => 2 },
          { 'available_filters' => %w[filter1] },
          'test_controller#index'
        ).must_equal({ 'filter1' => 1 })
      end

    end

    describe '#reset_filterrific_url' do

      it 'responds to #reset_filterrific_url' do
        TestController.new.must_respond_to(:reset_filterrific_url)
      end

    end

  end
end


