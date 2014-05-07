class ApplicationController < ActionController::Base
  protect_from_forgery

  def sign_in(user)
    @current_user = user
    session[:user_id] = @current_user.id
  end

  def sign_out
    @current_user = nil
    session.delete(:user_id)
    session[:did_sign_out] = true
  end

  def current_user
    if @current_user.nil? && !session[:user_id].nil?
      @current_user = User.find_by_id(session[:user_id])
    end
    @current_user
  end

  def authenticate
    redirect_to login_path if !current_user
  end

end
