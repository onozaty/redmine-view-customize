class ChangeDefaultBugfixOnViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def change
    change_column_default :view_customizes, :path_pattern, ""
    change_column_default :view_customizes, :comments, ""
  end
end
