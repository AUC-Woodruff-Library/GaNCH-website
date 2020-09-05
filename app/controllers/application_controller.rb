class ApplicationController < ActionController::Base
  before_action :set_var
  add_flash_types :info, :error, :warning

  @@permits_new_users = Rails.application.config.permit_signups

  private

  # allow controllers to decide whether to show sign up UI
  def set_var
    @permit_new_users = false
    if /yes|true/i =~ @@permits_new_users
      @permit_new_users = true
    end
  end

  def authenticate
    unless current_user
      session[:protected_page] = request.url
      redirect_to login_path, alert: "You need to login to view that page."
    end
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.find session[:user_id] if session[:user_id]
  end
  helper_method :current_user

  def from_kebab_case(str)
    return str.gsub('-', ' ')
  end


end
