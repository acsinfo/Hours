class ChangeDateFormatInHours < ActiveRecord::Migration
  def change
  	change_column :hours, :date, :datetime
  end
end
