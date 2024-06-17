class CreateSubTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :sub_tasks do |t|
      t.references :task, null: false, foreign_key: true
      t.string :sub_task_name
      t.string :status
      t.datetime :due_date
      t.integer :user_id

      t.timestamps
    end
  end
end
