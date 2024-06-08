class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.string :session_id
      t.string :user_id
      t.datetime :expires_at

      t.timestamps
    end
  end
end
