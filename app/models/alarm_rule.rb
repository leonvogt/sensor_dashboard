class AlarmRule < ApplicationRecord
  RULE_TYPES = %w(min_value max_value)

  belongs_to :sensor

  validates :rule_type, :value, presence: true
  validates :value, numericality: true

  scope :max_values, -> { where(rule_type: 'max_value') }
  scope :min_values, -> { where(rule_type: 'min_value') }
end
