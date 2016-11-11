module WeatherWeb
  class CacheCleaner
    require 'weather_web'
    include Sidekiq::Worker

    def perform
      yesterday = 1.day.ago
      to_be_deleted = FiveDayForecast.where(timestamp: yesterday.midnight..yesterday.end_of_day)
      to_be_deleted.each do |old_cache|
        FiveDayForecast.delete(old_cache)
      end
    end
  end
end