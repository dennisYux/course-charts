class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
  
  def after_sign_in_path_for(resource)
    session[:user_return_to].nil? ? user_root_path : session[:user_return_to].to_s
  end
end
