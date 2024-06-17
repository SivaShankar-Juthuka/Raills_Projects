class RemoveColumnFromSubTask < ActiveRecord::Migration[7.1]
  def change
    remove_column :sub_tasks, :user_id, :integer
  end
end
