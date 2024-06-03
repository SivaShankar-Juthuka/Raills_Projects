class CreateUserTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.string :task_name
      t.string :status
      t.date :due_date
      t.string :priority_level

      t.timestamps
    end
  end
end
