require_relative 'spec_helper'

describe WeatherWeb::ForecastData do
  describe '#get_city_id(params)' do
    let(:forecast) {WeatherWeb::ForecastData.new}

    it 'test the method output' do
      params = 'sofia'
      expect(forecast.get_city_id(params)).to equal(727011)
    end
  end

  describe '#request_weather(city_id)' do
    let(:forecast) {WeatherWeb::ForecastData.new}

    it 'must return record from Cache' do
      city_id = 727011
      expect(forecast.request_weather(city_id)).to include(:weather)
    end

    it 'must return weather-data from openweather API' do
      # it's tested with record that's not in the cache.
      # every time you run the test you must change the ID!
      city_id = 803611
      expect(forecast.request_weather(city_id)).to include(:weather)
    end
  end
end