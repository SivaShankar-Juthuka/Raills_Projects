class RecordSession < ApplicationRecord
  belongs_to :user
  attribute :active_session, :boolean, default: true
  def self.expire_sessions
    where("session_expiry < ? AND active_session = ?", Time.current, true).update_all(active_session: false)
  end
end
