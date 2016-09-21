class AddCacheTable < ActiveRecord::Migration
  def change
    create_table :cache do |c|
      c.string :city_name
      c.string :city_id
      c.string :temp
      c.string :weather
      c.timestamps
    end
  end
end