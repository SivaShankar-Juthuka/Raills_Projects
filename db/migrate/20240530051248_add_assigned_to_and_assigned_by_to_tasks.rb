class AddAssignedToAndAssignedByToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :assigned_to_id, :integer
    add_column :tasks, :assigned_by_id, :string
  end
end
