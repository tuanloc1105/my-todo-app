Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post 'auth/register', to: 'auth#register'
    end
  end

end
