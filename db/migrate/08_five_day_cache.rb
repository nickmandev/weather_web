class FiveDayCache < ActiveRecord::Migration
  def change
    create_table :weather do |t|
      t.string  :city_id
      t.string  :weather_type
      t.integer :temp_min
      t.integer :temp_max
      t.integer :temp
      t.datetime :timestamp
    end
  end
end