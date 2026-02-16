class FeatureFlagsController < ApplicationController
  def index
    render json: FeatureFlag.all
  end

  def show
    feature = FeatureFlag.find_by(name: params[:id])
    return render_not_found unless feature

    render json: feature
  end

  def create
    feature = FeatureFlag.new(feature_params)

    if feature.save
      render json: feature, status: :created
    else
      render json: { errors: feature.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    feature = FeatureFlag.find_by(name: params[:id])
    return render_not_found unless feature

    if feature.update(feature_params)
      render json: feature
    else
      render json: { errors: feature.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def evaluate
    enabled = FeatureEvaluator.enabled?(
      feature_name: params[:feature_name],
      user_id: params[:user_id],
      group_id: params[:group_id]
    )

    render json: { enabled: enabled }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def feature_params
    params.require(:feature_flag).permit(:name, :enabled, :description)
  end

  def render_not_found
    render json: { error: "Feature not found" }, status: :not_found
  end
end
