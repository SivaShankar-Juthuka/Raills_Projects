class AddSessionExpiryToRecordSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :record_sessions, :session_expiry, :datetime
  end
end
