class Favorites < ActiveRecord::Base
  self.table_name = 'favorites'
  belongs_to :user
end