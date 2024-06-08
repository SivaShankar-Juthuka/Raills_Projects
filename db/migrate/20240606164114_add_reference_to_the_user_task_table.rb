class AddReferenceToTheUserTaskTable < ActiveRecord::Migration[7.1]
  def change
    # add column that takes reference from task table
    add_reference :user_tasks, :task, foreign_key: true
    add_reference :tasks, :user, foreign_key: true
  end
end
