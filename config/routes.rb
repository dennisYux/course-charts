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
  #
  # it is better to define separate controllers for in progress, history ... ?
  #
  get '/account(.:format)', to: 'users#in_progress', as: :user_root
  get '/account/history(.:format)', to: 'users#history', as: :account_history
  get '/account/report(.:format)', to: 'users#report', as: :account_report

  scope 'account' do
  	resources :projects 
  end

  scope 'data' do
    get '/overview(.:format)', to: 'data#overview'
    get '/in-progress(.:format)', to: 'data#in_progress'
  end

  #get '/about', to: 'about#index', as: :about

end
