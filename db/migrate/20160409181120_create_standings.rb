class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings do |t|
      t.integer :team_id
      t.integer :season_id
      t.integer :lost
      t.integer :win
      t.float :pct
      t.float :gb
      t.integer :conf_win
      t.integer :conf_lost
      t.integer :div_win
      t.integer :div_lost
      t.integer :home_win
      t.integer :home_lost
      t.integer :road_win
      t.integer :road_lost
      t.integer :last_ten_win
      t.integer :last_ten_lost
      t.boolean :streak_as_win
      t.integer :streak_number
      t.integer :div_rank
      t.integer :conf_rank

      t.timestamps
    end
  end
end
