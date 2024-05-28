class AddForeignKeyToTasks < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :tasks, :users, column: :user_id
    add_foreign_key :tasks, :priorities, column: :priority_id

    add_index :tasks, :user_id
    add_index :tasks, :priority_id
  end
end