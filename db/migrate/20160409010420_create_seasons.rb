class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :start_year
      t.integer :end_year

      t.timestamps
    end
  end
end
