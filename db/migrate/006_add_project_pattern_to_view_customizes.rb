class AddProjectPatternToViewCustomizes < ActiveRecord::Migration[4.2]
  def up
    add_column :view_customizes, :project_pattern, :string, :null => false, :default => ""
  end

  def down
    remove_column :view_customizes, :project_pattern
  end
end

