Nyim::Application.routes.draw do

  resources :testimonials, :constraints => { :id => /\d+/ } do
    collection do
      get :manage
      get :list
    end
    member do
      put :manage_update
      get :manage_update
    end
  end
  resources :invoices, :constraints => { :id => /\d+/ } do
    collection do
      get :manage
      get :list
    end
  end

  resources :assets, :constraints => { :id => /\d+/ } do
    collection do
      get :manage
      get :list
      get :select
    end
    member do
      get :content
      get :download
    end
  end
  match '/assets/:asset' => 'assets#asset', :as => :display_asset, :constraints => { :asset => /.*/ }

  devise_for :users, :controllers => { :sessions => "sessions", :passwords => "forget_passwords" }

  devise_scope :user do
    get "/users/login" => "sessions#new", :as => :new_user_session
    post "/users/sign_in" => "sessions#create", :as => :user_session
    get "/users/sign_out" => "sessions#destroy", :as => :destroy_user_session
    get "/signup" => "users#new", :as => :new_user_registration
  end

  resources :users, :constraints => { :id => /\d+/ } do
    get :autocomplete, :on => :collection
  end


  resources :students do
    collection do
      get :list
      get :autocomplete
      get :sidebar
    end
  end

  resources :admins
  resources :trainers, :controller => :teachers do
    collection do
      get :list
      get :autocomplete
    end
  end
  resources :teachers do
    collection do
      get :list
      get :autocomplete
    end
  end

  resources :certificates

  resources :scheduled_sessions do
    collection do
      get :calendar_feed
    end
  end

  resources :scheduled_courses do
    collection do
      get :list
    end
    member do
      get :select
      put :add_seats
      put :remove_seats
      put :close
    end
  end

  resources :courses do
    collection do
      get :list
      get :promotions
    end
    member do
      get :select
    end
  end

  resources :course_groups do
    collection do
      get :list
    end
  end

  resources :sites, :except => [:new, :show] do
    collection do
      get :manage_emails
      delete :reset
      delete :clear
      #post :job
    end
  end

  resources :jobs, :constraints => { :id => /\d+/ }, :except => [:new, :create, :update] do
    member do
      put :restart
      put :fail
    end
    collection do
      get :list
      delete :clear
      post :launch
      get :tasks
    end
  end

  #resources :profiles

  resources :signups do
    collection do
      get :list
    end
    member do
      get :reschedule
      get :feedback
      get :certificate
      get :disclose_certificate
      get :cancel
      put :cancel_update
      put :save_for_later
      put :add_to_shopping_cart
      put :forget
      put :reschedule_update
      put :feedback_update
    end
  end

  match 'users/:student/shopping_cart' => 'signups#shopping_cart', :as => :shopping_cart

  resources :payments do
    collection do
      get :list
    end
  end

  resources :feedbacks do
    collection do
      get :list
      get :check
    end
    member do
      get :check_update
      put :check_update
    end
  end

  resources :locations do
    get :list, :on => :collection
  end

  resources :companies do
    collection do
      get :autocomplete
      get :list
    end
  end

  root :to => "assets#asset", :asset => 'main'

end
