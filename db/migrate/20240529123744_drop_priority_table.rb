class DropPriorityTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :priorities
  end
end
