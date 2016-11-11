module WeatherWeb
  class ApplicationWorker
    require 'weather_web'
    require_relative 'cache_cleaner.rb'
    require_relative 'cache_worker.rb'
    require_relative 'five_day_forecast_worker.rb'
    CacheWorker.perform_in(20.minutes)
    CacheCleaner.perform_in(1.day)
    FiveDayForecastWorker.perform_in(6.hours)
  end
end
