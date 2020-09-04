class UsersController < ApplicationController
  #skip_forgery_protection
  before_action :authenticate, except: [:new, :create]

  @@help_email = Rails.application.config.support_email

  def index
    @users = User.all
  end

  def new
    if @permit_new_users
      @user = User.new
    else
      @email = @@help_email
      @user = current_user
      render :forbidden
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      # Tell the UserMailer to send a welcome email after save
      UserMailer.with(user: @user).welcome_email.deliver_later

      login(@user)
      redirect_to root_path, notice: "Account Created."
    else
      render :new
    end
  end

  def show
    @user = current_user
  end

  def forbidden
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
