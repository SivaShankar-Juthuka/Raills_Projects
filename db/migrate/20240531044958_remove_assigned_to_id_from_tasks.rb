class RemoveAssignedToIdFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :assigned_by_id, :string
  end
end
