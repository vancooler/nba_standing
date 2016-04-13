class CreateConferences < ActiveRecord::Migration
  def change
    create_table :conferences do |t|
      t.string :conf_name

      t.timestamps
    end
  end
end
