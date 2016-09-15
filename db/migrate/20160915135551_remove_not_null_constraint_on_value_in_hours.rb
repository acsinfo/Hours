class RemoveNotNullConstraintOnValueInHours < ActiveRecord::Migration
  def change
  	change_column :hours, :value, :integer, null: true
  end
end
