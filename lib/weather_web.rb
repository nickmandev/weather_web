require "weather_web/version"
require 'weather_app'
require 'sinatra'
require 'bootstrap-sass'
require 'sass'
Dir[File.dirname(__FILE__) + '/weather_web/*.rb'].each {|file| require file}
require '/Users/nick/Developer/Projects/weather_web/assets/weather_web.css.sass'
module WeatherWeb
  unless defined? WEATHER_WEB_ROOT_PATH
    WEATHER_WEB_ROOT_PATH = File.dirname(File.dirname(__FILE__))
  end
end