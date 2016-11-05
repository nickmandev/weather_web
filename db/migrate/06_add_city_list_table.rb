class AddCityListTable < ActiveRecord::Migration
  def change
    create_table :city_list do |c|
      c.string :city_id
      c.string :city_name
      c.string :country
      c.string :latitude
      c.string :longitude
    end
  end
end