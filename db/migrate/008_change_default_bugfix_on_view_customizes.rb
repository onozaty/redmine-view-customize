class ChangeDefaultBugfixOnViewCustomizes < ActiveRecord::Migration[4.2]
  def up
    change_column_default :view_customizes, :path_pattern, ""
    change_column_default :view_customizes, :comments, ""
  end

  def down
    # Leave the default values unchanged
  end
end
