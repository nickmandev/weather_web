class AddFavoritesidOnFavorites < ActiveRecord::Migration
  def self.up
    add_column :favorites, :favorites_id, :string
    remove_column :users, :favorites
  end

  def self.down
    remove_column :favorites, :favorites_id
    add_column :users, :favorites
  end
end