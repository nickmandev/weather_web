require "weather_web/version"
require 'weather_app'
require 'sinatra'
require 'sinatra/static_assets'
require 'sinatra/reloader'
require 'application'
require 'sidekiq'
require 'redis'
require 'weather_web/workers/cache_worker'

Dir[File.dirname(__FILE__) + '/weather_web/*.rb'].each {|file| require file}

module WeatherWeb
  unless defined? WEATHER_WEB_ROOT_PATH
    WEATHER_WEB_ROOT_PATH = File.dirname(File.dirname(__FILE__))
  end
end
