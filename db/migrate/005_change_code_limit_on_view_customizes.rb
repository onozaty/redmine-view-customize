class ChangeCodeLimitOnViewCustomizes < ActiveRecord::Migration[4.2]
  def up
    change_column :view_customizes, :code, :text, :limit => 16.megabytes
  end

  def down
  end
end
