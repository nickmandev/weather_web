module WeatherWeb
  class FiveDayForecast < ActiveRecord::Base
    self.table_name = 'weather'

    def five_day_forecast(city_id,type_forecast)
      @common = WeatherApp::Common.new
      data = @common.get_data(city_id,type_forecast)
      cache_the_data(data)
    end

    def cache_the_data(forecast_data)
      forecast_data[:list].each do |data|
        FiveDayForecast.create(attributes = {
            city_id:      forecast_data[:city][:id],
            weather_type: data[:weather][0][:description],
            temp_min:     data[:main][:temp_min],
            temp_max:     data[:main][:temp_max],
            temp:         data[:main][:temp],
            timestamp:    Time.at(data[:dt])
        })
      end

      def search
        id = '727011'
        date = Date.today
        five_day_forecast = FiveDayForecast.where(timestamp: date.midnight..date.end_of_day).where(city_id: id)
        puts five_day_forecast
      end

    end
  end
end
