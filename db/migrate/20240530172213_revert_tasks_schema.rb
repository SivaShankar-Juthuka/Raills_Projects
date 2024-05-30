class RevertTasksSchema < ActiveRecord::Migration[7.1]
  def change
    # Revert the changes made to the tasks table
    change_table :tasks do |t|
      t.remove :assigned_by
      t.remove :assigned_to
      t.string :assigned_by_id
      t.integer :assigned_to_id
    end
  end
end
