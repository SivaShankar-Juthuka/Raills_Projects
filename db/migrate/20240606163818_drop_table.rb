class DropTable < ActiveRecord::Migration[7.1]
  def change
    # dropping user_session table
    drop_table :user_sessions
  end
end
