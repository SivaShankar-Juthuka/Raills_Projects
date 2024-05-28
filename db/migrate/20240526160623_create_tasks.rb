class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.string :status
      t.date :due_date
      t.references :user, null: false, foreign_key: true
      t.references :priority, null: false, foreign_key: true

      t.timestamps
    end
  end
end
