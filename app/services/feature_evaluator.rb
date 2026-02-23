class FeatureEvaluator
  def self.enabled?(feature_name:, user_id: nil, group_id: nil)

    feature = Rails.cache.fetch("feature_flag:#{feature_name}", expires_in: 5.minutes) do
      FeatureFlag.includes(:overrides).find_by!(name: feature_name)
    end

    enabled_for_feature(feature, user_id: user_id, group_id: group_id)
  end

  def self.enabled_for_feature(feature, user_id: nil, group_id: nil)
    overrides_by_type = feature.overrides.group_by(&:override_type)

    if user_id
      user_override = overrides_by_type["user"]&.find { |o| o.override_id == user_id }
      return user_override.enabled if user_override
    end

    if group_id
      group_override = overrides_by_type["group"]&.find { |o| o.override_id == group_id }
      return group_override.enabled if group_override
    end

    feature.enabled
  end
end