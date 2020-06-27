class ChangePathPatternDefaultOnViewCustomizes < ActiveRecord::CompatibleLegacyMigration.migration_class
  def change
    change_column_default :view_customizes, :path_pattern, from: nil, to: ""
    change_column_default :view_customizes, :comments, from: nil, to: ""
    change_column_null :view_customizes, :comments, false, ""
  end
end
