module WeatherWeb
  class FiveDayForecastWorker
    require 'weather_web'
    require 'weather_app'
    include Sidekiq::Worker

    def perform
      city_ids = []
      type_forecast = 'forecast'
      common = WeatherApp::Common.new
      favorites = Favorites.all
      favorites.each{|fav| city_ids.push(fav[:city_id])}
      city_ids = city_ids.uniq
      city_ids.each do |id|
        forecast_data = common.get_data(id,type_forecast)
        update_cache(forecast_data)
      end
    end

    def update_cache(forecast_data)
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
    end
    FiveDayForecastWorker.perform_in(5.minutes)
  end
end
