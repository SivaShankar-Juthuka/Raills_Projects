class RecordSession < ApplicationRecord
  belongs_to :user
  attribute :active_session, :boolean, default: true
end
