Saturn2::Application.routes.draw do
  if Rails.env.development?
    get 'impersonate/:user_id', to: 'test_impersonate#impersonate'
  end

  get 'directory', to: 'directory#show'
  resources :people
  resources :nmff_physicians

  resources :holidays

  resources :admin_messages
  resources :calendar_audits

  resource :profile
  put 'user_roles/:user_id', to: 'user_roles#update', as: :update_user_role

  resources :person_schedules
  resource :rotation_schedule
  resource :conference_schedule
  resource :front_desk_lunches
  resources :schedules do
    resources :weekly_calendars
  end

  root to: 'dashboards#show'
end
