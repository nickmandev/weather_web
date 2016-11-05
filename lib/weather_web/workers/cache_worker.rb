module WeatherWeb
  class CacheWorker
    require 'weather_web'
    include Sidekiq::Worker

    def perform
      cached = WeatherCache.all
      cached.each do |cache|
        update_favorites(cache.city_id)
        puts cache.city_name
      end
    end

    def update_favorites(city_id)
      type_of_forecast = 'weather'
      common = WeatherApp::Common.new
      cache = WeatherCache.find_by(:city_id => city_id)
      json = common.get_data(city_id,type_of_forecast)
      cache.update_attributes(
          :city_name  => json[:name],
          :temp       => json[:main][:temp],
          :weather    => json[:weather][0][:description].capitalize
      )
    end
    CacheWorker.perform_in(30.minutes)
  end
end
