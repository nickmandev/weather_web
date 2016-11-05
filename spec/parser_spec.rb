require_relative 'spec_helper'

describe WeatherWeb::DataParser do
  describe '#single_hash' do
    let(:parser) {WeatherWeb::DataParser.new}
    it 'should raise error' do
      test[:message] = 'not nil'
      expect(parser.single_hash(test)).to raise_error
    end
  end
end