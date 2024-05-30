class RemovePriorityFromTasks < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :tasks, :priorities if foreign_key_exists?(:tasks, :priorities)

    # Rename and change the column type
    rename_column :tasks, :priority_id, :priority_level
    change_column :tasks, :priority_level, :string
  end
end
