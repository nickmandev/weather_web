module WeatherWeb
  class Favorites < ActiveRecord::Base
    self.table_name = 'favorites'
    belongs_to :user

    def forecast_for_favorites(fav_array)
      type_forecast = "weather"
      forecast = ForecastData.new
      result = []
        fav_array.each do |arr|
          result << forecast.request_weather(arr.city_id,type_forecast)
        end
      result
    end

    def check_if_exist(current_user_id,param)
      curr_favorites = Favorites.where(users_id: current_user_id)
      curr_favorites.each do |curr_fav|
        if curr_fav.city_id.to_i == param.to_i
          return true
        end
      end
      false
    end
  end
end
