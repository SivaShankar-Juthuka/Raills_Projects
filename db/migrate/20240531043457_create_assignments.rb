class CreateAssignments < ActiveRecord::Migration[7.1]
  def change
    create_table :assignments do |t|
      t.references :task, null: false, foreign_key: true
      t.references :assigned_to, null: false, foreign_key: { to_table: :users }
      t.references :assigned_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :assignments, [:task_id, :assigned_to_id], unique: true
  end
end
