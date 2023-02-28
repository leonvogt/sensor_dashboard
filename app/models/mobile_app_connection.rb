class MobileAppConnection < ApplicationRecord
  PLATFORMS = %w(ios android).freeze

  belongs_to :user

  validates :platform, presence: true, inclusion: { in: PLATFORMS }
  validates :notification_token, presence: true, uniqueness: true
end
