class AddColumnToSubTask < ActiveRecord::Migration[7.1]
  def change
    add_column :sub_tasks, :created_user_id, :integer
  end
end
