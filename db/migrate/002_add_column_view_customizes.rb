class AddColumnViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def up
    add_column :view_customizes, :is_enabled, :boolean, :null => false, :default => true
    add_column :view_customizes, :is_private, :boolean, :null => false, :default => false
    add_column :view_customizes, :author_id,  :integer, :null => false, :default => 0
  end

  def down
    remove_column :view_customizes, :is_enabled
    remove_column :view_customizes, :is_private
    remove_column :view_customizes, :author_id
  end
end
