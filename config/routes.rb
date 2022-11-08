Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  namespace :api do
    namespace :v1 do
      resources :users
      post "login", to: "users#login"
      post 'password/forgot', to: 'passwords#forgot'
      post 'password/reset', to: 'passwords#reset'

      resources :biodata_users
      resources :posts
      get 'user/posts', to: 'posts#find'
      resources :family_trees
      resources :relations
      resources :events
      resources :user_relations
      post 'invitation/register', to: 'invitations#create'

      put 'accepted/invitation', to: 'invitations#accepted'

      resources  :notifications

      resources :group_chats
      get 'chats/:room_id' ,to: 'group_chats#messages'
      post 'chats/:room_id' ,to: 'group_chats#sending'
      post 'chats/:room_id/add' ,to: 'group_chats#add_participant'

      resources :personal_chats
      get 'chats/:room_id' ,to: 'personal_chats#messages'
      post 'chats/:room_id' ,to: 'personal_chats#sending'
    end
  end

end
