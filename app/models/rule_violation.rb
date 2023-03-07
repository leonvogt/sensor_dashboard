class RuleViolation < ApplicationRecord
  enum :status, [:open, :closed], default: :open

  belongs_to :alarm_rule

  scope :open, -> { where(status: :open) }
  scope :closed, -> { where(status: :closed) }

  validates :alarm_rule, :violation_text, presence: true

  def close!
    update!(status: :closed, closed_at: Time.current)
  end
end
