module WeatherWeb
  class Favorites < ActiveRecord::Base
    self.table_name = 'favorites'
    belongs_to :user

    def forecast_for_favorites(array)
      forecast = ForecastData.new
      result = []
        array.each do |arr|
          result << forecast.request_data(arr.city_id)
        end
      result
    end

    def check_if_exist(current_user,param)
      curr_favorites = user_favorites(current_user)
      curr_favorites.each do |curr_fav|
        if curr_fav.city_id.to_i == param.to_i
          return true
        end
      end
      false
    end
  end
end
