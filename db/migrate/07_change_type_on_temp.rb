class ChangeTypeOnTemp < ActiveRecord::Migration
  def up
    change_column :cache, :temp, :integer
  end

  def down
    change_column :cache, :temp, :string
  end
end