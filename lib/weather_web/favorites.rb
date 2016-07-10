class Favorites < ActiveRecord::Base
  self.table_name = 'favorites'
  belongs_to :user

    def list_favorites
      cur_usr = current_user
      fav = Favorites.where(user_id: cur_usr)
    end
end