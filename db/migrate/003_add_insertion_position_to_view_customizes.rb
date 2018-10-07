class AddInsertionPositionToViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def up
    add_column :view_customizes, :insertion_position, :string, :null => false, :default => "html_head"

    rename_column :view_customizes, :customize_type, :customize_type_old
    add_column :view_customizes, :customize_type, :string, :null => false, :default => "javascript"
    ActiveRecord::Base.connection.execute(
        "UPDATE view_customizes SET customize_type = 'css' WHERE customize_type_old = 2")
    remove_column :view_customizes, :customize_type_old

    change_column_null :view_customizes, :path_pattern, false
    change_column_null :view_customizes, :code, false
  end

  def down
    change_column_null :view_customizes, :path_pattern, true
    change_column_null :view_customizes, :code, true

    rename_column :view_customizes, :customize_type, :customize_type_new
    add_column :view_customizes, :customize_type, :integer, :default => 1
    ActiveRecord::Base.connection.execute(
        "UPDATE view_customizes SET customize_type = 1 WHERE customize_type_new = 'css'")
    remove_column :view_customizes, :customize_type_new

    remove_column :view_customizes, :insertion_position
  end
end
