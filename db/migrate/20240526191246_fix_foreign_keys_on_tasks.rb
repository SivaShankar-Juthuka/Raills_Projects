class FixForeignKeysOnTasks < ActiveRecord::Migration[7.1]
  def change
    # Removing duplicate foreign keys if they exist
    remove_foreign_key :tasks, :priorities if foreign_key_exists?(:tasks, :priorities)
    remove_foreign_key :tasks, :users if foreign_key_exists?(:tasks, :users)
    
    # Adding foreign keys correctly
    add_foreign_key :tasks, :priorities, column: :priority_id
    add_foreign_key :tasks, :users, column: :user_id
    
    # Ensuring indexes are in place
    add_index :tasks, :priority_id unless index_exists?(:tasks, :priority_id)
    add_index :tasks, :user_id unless index_exists?(:tasks, :user_id)
  end
end
