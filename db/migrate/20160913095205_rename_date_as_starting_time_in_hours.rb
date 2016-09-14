class RenameDateAsStartingTimeInHours < ActiveRecord::Migration
  def change
  	rename_column :hours, :date, :starting_time
  end
end
