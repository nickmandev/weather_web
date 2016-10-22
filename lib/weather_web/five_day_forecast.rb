module WeatherWeb
  class FiveDayForecast < ActiveRecord::Base
    def api_request(favorites)
      common = WeatherApp::Common.new
      result = []
      favorites.each do |fav|
        result << common.five_day_forecast(fav.id)
      end
    end

    def self.test_method(city_id)
      common = WeatherApp::Common.new
      test = common.five_day_forecast(city_id)
      puts test

    end
  end
end
