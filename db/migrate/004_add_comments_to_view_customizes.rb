class AddCommentsToViewCustomizes < ActiveRecord::Migration[4.2]
  def up
    add_column :view_customizes, :comments, :string, :null => true
  end

  def down
    remove_column :view_customizes, :comments
  end
end
