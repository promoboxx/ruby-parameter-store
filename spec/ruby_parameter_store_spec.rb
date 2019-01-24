require 'spec_helper'
require 'ruby_parameter_store'

RSpec.describe RubyParameterStore do

  context 'mocked' do

    let(:client) { double("aws client") }

    before do
      RubyParameterStore.configure do |config|
        config.environment = "local"
        config.app_name = "foobar",
        config.aws_client = client
      end

      params = {
        parameters: [
          { type: "string", name: "foo", value: "bar" },
          { type: "string", name: "larry", value: "bird" }
        ]
      }

      allow(client).to receive(:get_parameters_by_path).and_return(OpenStruct.new(params))
      allow(client).to receive(:must_get_parameters_by_path).and_return(OpenStruct.new(params))
    end

    it 'gets a param from a string' do
      expect(RubyParameterStore::Retrieve.get('foo')).to eq('bar')
    end

    it 'memoizes params' do
      RubyParameterStore::Retrieve.clear
      RubyParameterStore::Retrieve.get('foo')
      RubyParameterStore::Retrieve.get('foo')

      # calls out to aws twice by default, once for global and once for app-specific
      expect(client).to have_received(:get_parameters_by_path).twice
    end

    it 'clear will reset params memoization' do
      RubyParameterStore::Retrieve.clear
      RubyParameterStore::Retrieve.get('foo')
      RubyParameterStore::Retrieve.clear
      RubyParameterStore::Retrieve.get('foo')

      # calls out to aws twice by default, once for global and once for app-specific
      expect(client).to have_received(:get_parameters_by_path).exactly(4).times
    end

    it 'gets a param from a symbol' do
      expect(RubyParameterStore::Retrieve.get(:foo)).to eq('bar')
    end

    it 'returns nil when value is not present' do
      expect(RubyParameterStore::Retrieve.get('missing')).to be_nil
    end

    it 'must_get_parameter gets a param from a string' do
      expect(RubyParameterStore::Retrieve.get!('foo')).to eq('bar')
    end

    it 'must_get_parameter gets a param from a symbol' do
      expect(RubyParameterStore::Retrieve.get!(:foo)).to eq('bar')
    end

    it 'raises an error when must_get_parameter is called on a param that is not present' do
      expect{RubyParameterStore::Retrieve.get!('missing')}.to raise_error(RubyParameterStore::ParameterMissingError)
    end
  end

  context 'actual', skip: true do

    before do
      RubyParameterStore.reset
      RubyParameterStore.configure do |config|
        config.environment = "test"
        config.app_name = "test",
        config.aws_client = Aws::SSM::Client.new
      end
    end

    it 'gets global values' do
      expect(RubyParameterStore::Retrieve.get_parameter(:test2)).to eq('globaltest2')
    end

    it 'overrides global values when there is a configured value for the app' do
      expect(RubyParameterStore::Retrieve.get_parameter(:test1)).to eq('testtest1')
    end
  end
end

