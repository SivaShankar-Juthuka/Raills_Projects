class RemoveColumnsFromUserTasks < ActiveRecord::Migration[7.1]
  def change
    # remove task_name and due_date
    remove_column :user_tasks, :task_name, :string
    remove_column :user_tasks, :due_date, :datetime
  end
end
