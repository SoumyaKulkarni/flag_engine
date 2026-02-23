class FeatureFlagsController < ApplicationController
  def index
    page     = params.fetch(:page, 1).to_i
    per_page = params.fetch(:per_page, 10).to_i

    page = 1 if page < 1
    per_page = 10 if per_page <= 0

    total_count = FeatureFlag.count

    flags = FeatureFlag
              .limit(per_page)
              .offset((page - 1) * per_page)

    render json: {
      data: flags,
      meta: {
        page: page,
        per_page: per_page,
        total_count: total_count,
        total_pages: (total_count / per_page.to_f).ceil
      }
    }
  end

  def show
    flag = FeatureFlag.find(params[:id])
    render json: flag
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feature flag not found" }, status: :not_found
  end

  def create
    feature = FeatureFlag.new(feature_params)

    if feature.save
      render json: feature, status: :created
    else
      render json: { errors: feature.errors.full_messages },
             status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    render json: {
      error: "Duplicate feature flag",
      details: "Feature flag name must be unique"
    }, status: :unprocessable_entity
  end


  def update
    flag = FeatureFlag.find(params[:id])

    if flag.update(feature_flag_params)
      render json: flag
    else
      render json: { errors: flag.errors.full_messages },
             status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feature flag not found" },
           status: :not_found

  rescue ActiveRecord::RecordNotUnique
    render json: {
      error: "Duplicate feature flag name"
    }, status: :unprocessable_entity
  end

  def destroy
    flag = FeatureFlag.find(params[:id])
    flag.destroy
    head :no_content

  rescue ActiveRecord::RecordNotFound
    render json: { error: "Feature flag not found" },
           status: :not_found
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

  def evaluate_batch
    feature_names = params[:feature_names]

    return render json: { error: "feature_names parameter is required" },
                  status: :bad_request if feature_names.blank?

    features = FeatureFlag
                 .includes(:overrides)
                 .where(name: feature_names)
                 .index_by(&:name)

    results = feature_names.each_with_object({}) do |name, hash|
      feature = features[name]

      if feature.nil?
        hash[name] = "not_found"
        next
      end

      hash[name] = FeatureEvaluator.enabled_for_feature(
        feature,
        user_id: params[:user_id],
        group_id: params[:group_id]
      )
    end

    render json: { results: results }
  end

  private

  def feature_params
    params.require(:feature_flag).permit(:name, :enabled, :description)
  end

  def render_not_found
    render json: { error: "Feature not found" }, status: :not_found
  end
end
