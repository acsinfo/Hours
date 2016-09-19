class AddEndingTimeToHours < ActiveRecord::Migration
  def change
  	add_column :hours, :ending_time, :datetime
  end
end
