class CreateUserTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tasks do |t|
      t.integer :assigned_to
      t.integer :assigned_by
      t.string :task_name
      t.string :status
      t.datetime :due_date

      t.timestamps
    end
  end
end
