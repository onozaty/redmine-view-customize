class ChangeCodeLimitOnViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def up
    change_column :view_customizes, :code, :text, :limit => 16.megabytes
  end

  def down
  end
end
