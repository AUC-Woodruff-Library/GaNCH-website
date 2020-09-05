class UsersController < ApplicationController
  #skip_forgery_protection
  before_action :authenticate, except: [:new, :create]
  before_action :load_user, only: [:show, :edit, :update, :destroy]

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
    # make current user available to view
    @current_user = current_user
    if @user == @current_user
      flash.now[:warning] = 'Currently logged in as this user.'
    end
  end

  def forbidden
  end

  def destroy
    @current_user = current_user
    # only admin can destroy users
    @notice = 'You are not authorized to delete users.'

    if @current_user == User.first
      if @current_user != @user
        @user.destroy
        @notice = 'User was successfully removed.'
        respond_to do |format|
          format.html { redirect_to users_url, notice: @notice }
          format.json { head :no_content }
        end
        return
      else
        @notice = 'Unable to delete your own user record.'
      end
    end
    respond_to do |format|
      format.html { redirect_to users_url, error: @notice }
      format.json { head :no_content }
    end
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
