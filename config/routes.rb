Rails.application.routes.draw do
  resources :feature_flags, only: [:index, :show, :create, :update]
  resources :overrides, only: [:create, :update, :destroy]

  post "evaluate", to: "feature_flags#evaluate"
  post "/evaluate_batch", to: "feature_flags#evaluate_batch"
end
