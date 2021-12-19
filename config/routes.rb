Rails.application.routes.draw do
  get 'chats/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]
	devise_for :users, controllers: {
    sessions: "public/sessions",
    registrations: "public/registrations"
  }
  post 'follow/:id' => 'relationships#follow',as: 'follow' #フォローする
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow' #アンフォローする
  resources :users,only: [:show,:edit,:update,:index] do
    get "search", to: "users#search"
    member do
      get 'followers'
      get 'followings'
      
    end
    resource :relationships, only: [:create, :destroy]
  end
  
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create]
  end

  resources :book_comments, only: [:destroy]

  root 'home#top'
  get 'home/about'
  get '/search' => 'search#search'

  resources :groups do
    get "join" => "groups#join"
  end  

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
