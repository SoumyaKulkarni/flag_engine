require "rails_helper"

RSpec.describe FeatureEvaluator do

  let!(:feature) do
    FeatureFlag.create!(
      name: "new_ui",
      enabled: false
    )
  end

  describe ".enabled?" do

    it "returns global default when no overrides" do
      result = FeatureEvaluator.enabled?(feature_name: "new_ui")
      expect(result).to eq(false)
    end

    it "uses user override when present" do
      feature.overrides.create!(
        override_type: "user",
        override_id: 1,
        enabled: true
      )

      result = FeatureEvaluator.enabled?(
        feature_name: "new_ui",
        user_id: 1
      )

      expect(result).to eq(true)
    end

    it "uses group override when user override absent" do
      feature.overrides.create!(
        override_type: "group",
        override_id: 10,
        enabled: true
      )

      result = FeatureEvaluator.enabled?(
        feature_name: "new_ui",
        group_id: 10
      )

      expect(result).to eq(true)
    end

    it "prefers user override over group override" do
      feature.overrides.create!(
        override_type: "group",
        override_id: 10,
        enabled: false
      )

      feature.overrides.create!(
        override_type: "user",
        override_id: 1,
        enabled: true
      )

      result = FeatureEvaluator.enabled?(
        feature_name: "new_ui",
        user_id: 1,
        group_id: 10
      )

      expect(result).to eq(true)
    end

    it "raises error when feature does not exist" do
      expect {
        FeatureEvaluator.enabled?(feature_name: "missing_feature")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end
end
