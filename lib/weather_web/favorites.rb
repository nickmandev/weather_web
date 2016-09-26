module WeatherWeb
  class Favorites < ActiveRecord::Base
    self.table_name = 'favorites'
    belongs_to :user
      def user_favorites(current_user)
        favorites = Favorites.all
        curr_fav = []
        favorites.each{|fav| curr_fav.push(fav) if fav.users_id == current_user.id}
        curr_fav
      end

      def forecast_for_favorites(arr)
        forecast = ForecastData.new
        result = []
          arr.each do |arr|
            result << forecast.request_data(arr.city_id)
          end
        result
      end

      def check_if_exist(current_user,param)
        curr_fav = user_favorites(current_user)
        curr_fav.each do |curr_fav|
          if curr_fav.city_id.to_i == param.to_i
            return true
          else
            return false
          end
        end
      end
  end
end
