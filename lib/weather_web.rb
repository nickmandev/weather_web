require "weather_web/version"
require 'weather_app'
require 'sinatra'
require 'bootstrap-sass'
Dir[File.dirname(__FILE__) + '/weather_web/*.rb'].each {|file| require file}
module WeatherWeb


end