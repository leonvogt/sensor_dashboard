class Device < ApplicationRecord
  belongs_to :user
  has_many :sensors, dependent: :destroy
  has_many :api_errors, dependent: :destroy

  validates :name, presence: true
  validates :access_token, uniqueness: true, allow_nil: true

  accepts_nested_attributes_for :sensors, allow_destroy: true

  def to_s
    name
  end
end
