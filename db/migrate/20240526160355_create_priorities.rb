class CreatePriorities < ActiveRecord::Migration[7.1]
  def change
    create_table :priorities do |t|
      t.string :priority_level

      t.timestamps
    end
  end
end
