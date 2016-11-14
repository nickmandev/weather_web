module WeatherWeb
  require 'sidekiq-cron'
  require_relative '../../lib/weather_web/workers/cache_cleaner.rb'
  require_relative '../../lib/weather_web/workers/five_day_forecast_worker'
  require_relative '../../lib/weather_web/workers/cache_worker'

  Sidekiq.configure_server do |config|
    schedule_file = 'config/sidekiq_schedule.yml'

    if File.exists?(schedule_file) && Sidekiq.server?
      Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
    end
  end
end
