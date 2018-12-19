require 'parameter_store'

describe ParameterStore do

  context 'mock' do
    before do
      allow(ParameterStore).to receive(:params).and_return({p1: 'value'})
    end

    it 'gets a param from a string' do
      expect(ParameterStore.get_parameter('p1')).to eq('value')
    end

    it 'gets a param from a symbol' do
      expect(ParameterStore.get_parameter(:p1)).to eq('value')
    end

    it 'returns nil when value is not present' do
      expect(ParameterStore.get_parameter('p2')).to be_nil
    end

    it 'must_get_parameter gets a param from a string' do
      expect(ParameterStore.must_get_parameter('p1')).to eq('value')
    end

    it 'must_get_parameter gets a param from a symbol' do
      expect(ParameterStore.must_get_parameter(:p1)).to eq('value')
    end

    it 'raises an error when must_get_parameter is called on a param that is not present' do
      expect{ParameterStore.must_get_parameter(:p2)}.to raise_error(ParameterStore::ParameterMissingError)
    end
  end

  context 'actual' do

    before do
      ParameterStore.configure('test','test')
    end

    it ' gets global values ' do
      expect(ParameterStore.get_parameter(:test2)).to eq('globaltest2')
    end

    it ' overrides global values when there is a configured value for the app' do
      expect(ParameterStore.get_parameter(:test1)).to eq('testtest1')
    end
  end

end

