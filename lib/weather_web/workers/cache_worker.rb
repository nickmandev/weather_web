module WeatherWeb
  class CacheWorker
    require 'weather_web'
    include Sidekiq::Worker

    def perform
      cached = WeatherCache.all
      cached.each do |cache|
        if cache.updated_at < 30.minutes.ago
          update_favorites(cache[:city_id])
        end
      end
    end

    def update_favorites(city_id)
      type_of_forecast = 'weather'
      common = WeatherApp::Common.new
      cache = WeatherCache.find_by(:city_id => city_id)
      json = common.get_data(city_id,type_of_forecast)
      cache.update_attributes(
          :city_name  => json[:name],
          :temp       => json[:main][:temp].to_i,
          :weather    => json[:weather][0][:description].capitalize
      )
    end
    CacheWorker.perform_in(20.minutes.ago)
  end
end
