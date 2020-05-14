class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def authenticate
    unless user_signed_in?
      session[:return_to] = request.env["PATH_INFO"]
      redirect_to root_path
    end
  end

  def no_auth_allowed
    redirect_to "/matches" if user_signed_in?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
    !!current_user
  end

  def index
    no_auth_allowed
  end
end
