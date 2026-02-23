class FeatureEvaluator
  def self.enabled?(feature_name:, user_id: nil, group_id: nil)

    feature = Rails.cache.fetch("feature_flag:#{feature_name}", expires_in: 5.minutes) do
      FeatureFlag.includes(:overrides).find_by!(name: feature_name)
    end

    overrides = feature.overrides

    if user_id
      user_override = overrides.find do |o|
        o.override_type == "user" && o.override_id == user_id
      end
      return user_override.enabled unless user_override.nil?
    end

    if group_id
      group_override = overrides.find do |o|
        o.override_type == "group" && o.override_id == group_id
      end
      return group_override.enabled unless group_override.nil?
    end

    feature.enabled
  end

  def self.enabled_for_feature(feature, user_id: nil, group_id: nil)
    overrides = feature.overrides

    if user_id
      user_override = overrides.find { |o| o.override_type == "user" && o.override_id == user_id }
      return user_override.enabled unless user_override.nil?
    end

    if group_id
      group_override = overrides.find { |o| o.override_type == "group" && o.override_id == group_id }
      return group_override.enabled unless group_override.nil?
    end

    feature.enabled
  end
end
