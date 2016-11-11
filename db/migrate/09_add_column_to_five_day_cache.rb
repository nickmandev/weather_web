class AddColumnToFiveDayCache < ActiveRecord::Migration
  def up
    add_column :weather, :city_name, :string
  end

  def down
    remove_column :weather, :city_name
  end
end