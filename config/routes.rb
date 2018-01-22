Rails.application.routes.draw do
  resources :drg_provider_details, path: '/providers', defaults: {format: :json}
  resources :states, defaults: {format: :json}
end
