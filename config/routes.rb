Questionnaire::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get "/users/(:type)", to: "users#index", type: /deleted/, as: "users"

  resources :users, except: [:show, :new, :index]

  concern :nested_questions do
    resources :questions, only: :index
  end

  resources :question_levels, concerns: :nested_questions
  resources :categories, concerns: :nested_questions

  get "/questions/(:type)", to: "questions#index", type: /Subjective|Mcq|Mcqma/, :as => :questions_list

  resources :questions do
    collection do 
      get :autocomplete_tag_name
      get :autocomplete_category_name
    end
    member do 
      put :publish
      put :unpublish
    end
  end

  resources :test_sets, except: [:edit, :update, :destroy] do 
    member do 
      get :download_sets
    end
  end

  resources :subjectives, :controller => "questions", :type => "Subjective"
  resources :mcq, :controller => "questions", :type => "Mcq"
  resources :mcqma, :controller => "questions", :type => "Mcqma"

  root :to => "home#index"
  get 'show_tag', :to => "home#show_tag", :as => :show_tag
  get 'search_questions', :to => "test_sets#search_questions", :as => :search_questions
end
