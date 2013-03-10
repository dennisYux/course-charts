Boarder::Application.routes.draw do

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"

  # 
  # once a user has successfully signed in
  # a redirection from routes /users to /account happens
  #   
  devise_for :users, skip: [:registrations] do
    get    '/users/sign_up(.:format)', to: 'devise::registrations#new',    as: :new_user_registration
    post   '/users(.:format)',         to: 'devise::registrations#create', as: :user_registration
    get    '/account/edit(.:format)',  to: 'devise::registrations#edit',   as: :edit_account
    put    '/account(.:format)',       to: 'devise::registrations#update', as: :account
    get    '/users/cancel(.:format)',  to: 'devise::registrations#cancel', as: :cancel_user_registration
		delete '/users(.:format)',         to: 'devise::registrations#destroy'	
	end

  get '/admin(.:format)', to: 'users#index', as: :admin  
  get '/account(.:format)', to: 'users#show'

  scope 'account' do
  	resources :projects do
      resources :tasks
    end
  end
end