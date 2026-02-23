require "rails_helper"

RSpec.describe "FeatureFlags API", type: :request do

  describe "GET /feature_flags" do
    it "returns paginated feature flags" do
      FeatureFlag.create!(name: "flag_1", enabled: true)

      get "/feature_flags"

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["data"].length).to eq(1)
    end
  end

  describe "POST /feature_flags" do
    it "creates a feature flag" do
      post "/feature_flags", params: {
        feature_flag: {
          name: "new_feature",
          enabled: true
        }
      }

      expect(response).to have_http_status(:created)
      expect(FeatureFlag.last.name).to eq("new_feature")
    end
  end

  describe "POST /evaluate" do
    it "evaluates feature flag" do
      FeatureFlag.create!(name: "eval_test", enabled: true)

      post "/evaluate", params: {
        feature_name: "eval_test"
      }

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json["enabled"]).to eq(true)
    end
  end

end
