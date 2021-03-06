require 'sidekiq/web'

Testtable::Application.routes.draw do
#get "/atom.xml" => redirect('http://blog.diasporafoundation.org/feed/atom') #too many stupid redirects :()

  get 'oembed' => 'posts#oembed', :as => 'oembed'
  # Posting and Reading
  resources :reshares

  resources :status_messages, :only => [:new, :create]

  resources :posts do
    member do
      get :next
      get :previous
      get :interactions
    end

    resources :likes, :only => [:create, :destroy, :index ]
    resources :comments, :only => [:new, :create, :destroy, :index]
  end

  get 'p/:id' => 'posts#show', :as => 'short_post'
  get 'posts/:id/iframe' => 'posts#iframe', :as => 'iframe'

  # roll up likes into a nested resource above
  resources :comments, :only => [:create, :destroy] do
    resources :likes, :only => [:create, :destroy, :index]
  end

  # Streams
  get "explore" => "streams#multi", :as => "stream"                 # legacy

  get "stream" => "streams#multi", :as => "stream"
  get "public" => "streams#public", :as => "public_stream"
  get "followed_tags" => "streams#followed_tags", :as => "followed_tags_stream"
  get "mentions" => "streams#mentioned", :as => "mentioned_stream"
  get "liked" => "streams#liked", :as => "liked_stream"
  get "commented" => "streams#commented", :as => "commented_stream"
  get "aspects" => "streams#aspects", :as => "aspects_stream"

  resources :aspects do
    put :toggle_contact_visibility
  end

  get 'bookmarklet' => 'status_messages#bookmarklet'

  get 'notifications/read_all' => 'notifications#read_all'
  resources :notifications, :only => [:index, :update] do
  end

  resources :tags, :only => [:index]

  resources "tag_followings", :only => [:create, :destroy, :index]

  get 'tags/:name' => 'tags#show', :as => 'tag'

  resources :apps, :only => [:show]

  #Cubbies info page

  resource :token, :only => :show

  # Users and people

  resource :user, :only => [:edit, :update, :destroy], :shallow => true do
    get :getting_started_completed
    get :export
  end

  controller :users do
    get 'public/:username'          => :public,           :as => 'users_public'
    match 'getting_started'         => :getting_started,  :as => 'getting_started'
    match 'privacy'                 => :privacy_settings, :as => 'privacy_settings'
    get 'getting_started_completed' => :getting_started_completed
    get 'confirm_email/:token'      => :confirm_email,    :as => 'confirm_email'
  end

  # This is a hack to overide a route created by devise.
  # I couldn't find anything in devise to skip that route, see Bug #961
  match 'users/edit' => redirect('/user/edit')


  scope 'admins', :controller => :admins do
    match :user_search
    get   :admin_inviter
    get   :weekly_user_stats
    get   :correlations
    get   :stats, :as => 'pod_stats'
  end

  resource :profile, :only => [:edit, :update]
  resources :profiles, :only => [:show]


  resources :contacts,           :except => [:update, :create] do
    get :sharing, :on => :collection
  end
  resources :aspect_memberships, :only  => [:destroy, :create]
  resources :share_visibilities,  :only => [:update]
  resources :blocks, :only => [:create, :destroy]

  get 'people/refresh_search' => "people#refresh_search"
  resources :people, :except => [:edit, :update] do
    resources :status_messages
    resources :photos
    get :contacts
    get "aspect_membership_button" => :aspect_membership_dropdown, :as => "aspect_membership_button"
    get :hovercard

    member do
      get :last_post
    end

    collection do
      post 'by_handle' => :retrieve_remote, :as => 'person_by_handle'
      get :tag_index
    end
  end
  get '/u/:username' => 'people#show', :as => 'user_profile'
  get '/u/:username/profile_photo' => 'users#user_photo'


  # Federation

  controller :publics do
    get 'webfinger'             => :webfinger
    get 'hcard/users/:guid'     => :hcard
    get '.well-known/host-meta' => :host_meta
    post 'receive/users/:guid'  => :receive
    post 'receive/public'       => :receive_public
    get 'hub'                   => :hub
  end



  # External

  resources :services, :only => [:index, :destroy]
  controller :services do
    scope "/auth", :as => "auth" do
      match ':provider/callback' => :create
      match :failure
    end
    scope 'services' do
      match 'inviter/:provider' => :inviter, :as => 'service_inviter'
      match 'finder/:provider'  => :finder,  :as => 'friend_finder'
    end
  end

  scope 'api/v0', :controller => :apis do
    get :me
  end

  namespace :api do
    namespace :v0 do
      get "/users/:username" => 'users#show', :as => 'user'
      get "/tags/:name" => 'tags#show', :as => 'tag'
    end
  end

  get 'community_spotlight' => "contacts#spotlight", :as => 'community_spotlight'

  #devise_for :users

  #rewrite devise's registration class,so I can change behavior of sign_up and login!
  devise_for :users, :controllers => {:registrations => "registrations",
                                      :sessions => "sessions"}
  devise_scope :user do
    get "/login" => "sessions#new"
    get "/register" => "registrations#new"
  end 

  root :to => 'home#index'
  get "home/index"
end
