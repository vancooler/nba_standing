class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :div_name
      t.integer :conf_id

      t.timestamps
    end
  end
end
