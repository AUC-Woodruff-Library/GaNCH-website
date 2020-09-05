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

  def destroy
    @current_user = current_user
    if @current_user == User.first
      @user.destroy
    else
      flash.now[:warn] = 'You are not authorized to delete users.'
    end
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
