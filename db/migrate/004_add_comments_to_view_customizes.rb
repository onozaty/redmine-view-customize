class AddCommentsToViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def up
    add_column :view_customizes, :comments, :string, :null => true
  end

  def down
    remove_column :view_customizes, :comments
  end
end
