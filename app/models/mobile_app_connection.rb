class MobileAppConnection < ApplicationRecord
  PLATFORMS = %w[ios android].freeze

  belongs_to :user

  before_validation { self.platform = platform.to_s.downcase }
  validates :platform, presence: true, inclusion: {in: PLATFORMS}
  validates :notification_token, presence: true, uniqueness: true

  scope :ios, -> { where(platform: "ios") }
  scope :android, -> { where(platform: "android") }

  def to_s
    name.presence || notification_token.truncate(10)
  end
end
