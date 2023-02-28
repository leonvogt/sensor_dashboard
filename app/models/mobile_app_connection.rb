class MobileAppConnection < ApplicationRecord
  PLATFORMS = %w(ios android).freeze

  belongs_to :user

  validates :platform, presence: true, inclusion: { in: PLATFORMS }
  validates :unique_mobile_id, :notification_token, presence: true, uniqueness: true
end
