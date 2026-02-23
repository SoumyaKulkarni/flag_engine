class OverridesController < ApplicationController

  def create
    feature = FeatureFlag.find_by!(name: params[:feature_name])

    override = feature.overrides.new(override_params)

    if override.save
      render json: override, status: :created
    else
      render json: { errors: override.errors.full_messages },
             status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feature flag not found" },
           status: :not_found

  rescue ActiveRecord::RecordNotUnique
    render json: {
      error: "Duplicate override",
      details: "Override already exists for this scope"
    }, status: :unprocessable_entity
  end

  def update
    override = Override.find(params[:id])

    if override.update(override_params)
      render json: override
    else
      render json: { errors: override.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    override = Override.find(params[:id])
    override.destroy

    head :no_content
  end

  private

  def override_params
    params.require(:override).permit(:override_type, :override_id, :enabled)
  end

  def render_not_found
    render json: { error: "Feature not found" }, status: :not_found
  end
end

