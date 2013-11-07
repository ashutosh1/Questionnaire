Questionnaire::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get "/users/(:type)", to: "users#index", type: /deleted/, as: "users"

  resources :users, except: [:edit, :new, :index]

  concern :nested_questions do
    resources :questions, only: :index
  end

  resources :question_types, concerns: :nested_questions
  resources :question_levels, concerns: :nested_questions
  resources :categories, concerns: :nested_questions
  
  resources :questions do
    collection do 
      get :autocomplete_tag_name
    end
    member do 
      delete :remove_tag
      put :publish
      put :unpublish
    end
  end

  resources :test_sets, except: [:edit, :update, :destroy] do 
    member do 
      get :download_sets
    end
  end

  get "/get_options", to: "questions#get_options"
  root :to => "home#index"
  get 'show_tag', :to => "home#show_tag", :as => :show_tag
end
