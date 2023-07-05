class AlarmRule < ApplicationRecord
  RULE_TYPES = %w[min_value max_value]

  belongs_to :sensor
  has_many :rule_violations, dependent: :destroy

  validates :rule_type, :value, presence: true
  validates :value, numericality: true

  scope :max_values, -> { where(rule_type: "max_value") }
  scope :min_values, -> { where(rule_type: "min_value") }

  before_destroy :delete_rule_violations, prepend: true

  private

  # Delete rule violations manually, so we only execute one query instead of one per rule violation.
  def delete_rule_violations
    rule_violations.delete_all
  end
end
