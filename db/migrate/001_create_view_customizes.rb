class CreateViewCustomizes < ActiveRecord::Migration[4.2]
  def change
    create_table :view_customizes do |t|
      t.string :path_pattern
      t.integer :customize_type
      t.text :code
    end
  end
end
