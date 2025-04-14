Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do

      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      post "user/info", to: "auth#info"

      post "tasks/add", to: "tasks#add"
      post "tasks/list_all_tasks", to: "tasks#list_all_tasks"
      post "tasks/task_info", to: "tasks#task_info"
      post "tasks/update_task_info", to: "tasks#update_task_info"

    end
  end

end
