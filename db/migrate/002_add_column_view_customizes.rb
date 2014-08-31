class AddColumnViewCustomizes < ActiveRecord::Migration
  def up
    add_column :view_customizes, :is_enabled, :boolean, :null => false, :default => true
    add_column :view_customizes, :is_private, :boolean, :null => false, :default => false
  end

  def down
    add_column :view_customizes, :is_enabled, :boolean
    add_column :view_customizes, :is_private, :boolean
  end
end
