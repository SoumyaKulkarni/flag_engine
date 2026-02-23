class FeatureFlag < ApplicationRecord
  has_many :overrides, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :enabled, inclusion: { in: [true, false] }
  after_commit :invalidate_cache

  def invalidate_cache
    Rails.cache.delete("feature_flag:#{name}")
  end
end
