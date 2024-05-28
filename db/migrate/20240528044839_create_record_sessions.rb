class CreateRecordSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :record_sessions do |t|
      t.string :session_id
      t.references :user, null: false, foreign_key: true
      t.boolean :active_session, default: true

      t.timestamps
    end
  end
end
