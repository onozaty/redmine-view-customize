class ChangePathPatternDefaultOnViewCustomizes < ActiveRecord::Migration[4.2]
  def change
    change_column_default :view_customizes, :path_pattern, from: nil, to: ""
    change_column_default :view_customizes, :comments, from: nil, to: ""
    change_column_null :view_customizes, :comments, false, ""
  end
end
