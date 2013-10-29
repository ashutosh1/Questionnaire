Questionnaire::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get "/users/(:type)", to: "users#index", as: "users"
  resources :users, except: [:edit, :new, :index]
  resources :question_types
  resources :question_levels
  resources :categories

  root :to => "home#index"  
end
