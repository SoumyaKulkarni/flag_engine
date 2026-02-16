class Override < ApplicationRecord
  belongs_to :feature_flag
  validates :override_type, presence: true, inclusion: { in: %w[user group] }
  validates :override_id, presence: true
  validates :enabled, inclusion: { in: [true, false] }
end
