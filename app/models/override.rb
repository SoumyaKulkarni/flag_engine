class Override < ApplicationRecord
  belongs_to :feature_flag
  validates :override_type, presence: true, inclusion: { in: %w[user group] }
  validates :override_id, presence: true
  validates :enabled, inclusion: { in: [true, false] }
  after_commit :invalidate_feature_cache

  def invalidate_feature_cache
    Rails.cache.delete("feature_flag:#{feature_flag.name}")
  end
end
