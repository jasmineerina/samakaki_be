Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  namespace :api do
    namespace :v1 do
      mount ActionCable.server => '/cable'
      resources :users
      post "login", to: "users#login"
      post 'password/forgot', to: 'passwords#forgot'
      post 'password/reset', to: 'passwords#reset'
      get "confirm/email" ,to: "users#confirm_email"

      resources :biodata_users
      resources :posts
      get 'user/posts', to: 'posts#find'
      get 'user/my_post', to:'posts#my_posts'
      resources :family_trees
      resources :relations
      resources :events
      resources :user_relations
      get 'get_relations/connected_user', to: 'user_relations#get_connected_relation'
      post 'invitation/register', to: 'invitations#create'
      post 'invite/users', to: 'relations#create_notif_invited_user'
      put 'accepted/invitation', to: 'invitations#accepted'

      resources  :notifications

      resources :group_chats
      get 'chats/:room_id' ,to: 'group_chats#messages'
      post 'chats/:room_id' ,to: 'group_chats#sending'
      post 'chats/:room_id/add' ,to: 'group_chats#add_participant'

      resources :personal_chats
      end
  end

end
