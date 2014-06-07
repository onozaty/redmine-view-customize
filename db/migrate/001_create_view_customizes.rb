class CreateViewCustomizes < ActiveRecord::Migration
  def change
    create_table :view_customizes do |t|
      t.string :path_pattern
      t.integer :type
      t.text :script
    end
  end
end
