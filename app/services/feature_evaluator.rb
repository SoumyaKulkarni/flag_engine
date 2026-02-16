class FeatureEvaluator
  def self.enabled?(feature_name:, user_id: nil, group_id: nil)
    feature = FeatureFlag.find_by(name: feature_name)
    raise ActiveRecord::RecordNotFound, "Feature not found" unless feature

    if user_id
      user_override = feature.overrides.find_by(
        override_type: "user",
        override_id: user_id
      )
      return user_override.enabled unless user_override.nil?
    end

    if group_id
      group_override = feature.overrides.find_by(
        override_type: "group",
        override_id: group_id
      )
      return group_override.enabled unless group_override.nil?
    end

    feature.enabled
  end
end
