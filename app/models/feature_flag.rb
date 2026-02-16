class FeatureFlag < ApplicationRecord
  has_many :overrides, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :enabled, inclusion: { in: [true, false] }
end
