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
  end
end