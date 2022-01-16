class ChangeDefaultBugfixOnViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def up
    change_column_default :view_customizes, :path_pattern, ""
    change_column_default :view_customizes, :comments, ""
  end

  def down
    # Leave the default values unchanged
  end
end
