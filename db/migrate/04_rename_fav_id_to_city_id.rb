class RenameFavIdToCityId < ActiveRecord::Migration
  def self.up
    rename_column :favorites, :favorites_id, :city_id
  end

  def self.down
    rename_column :favorites, :city_id, :favorites_id
  end
end