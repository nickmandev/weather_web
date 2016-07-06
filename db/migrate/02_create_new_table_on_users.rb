class CreateNewTableOnUsers < ActiveRecord::Migration
  def change
    create_table :favorites do |f|
      f.belongs_to :users
      f.string :name
    end
  end
end