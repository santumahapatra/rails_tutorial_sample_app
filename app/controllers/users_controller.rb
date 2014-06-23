class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_filter :signed_in_user_filter, only: [:new, :create]
  before_filter :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def new
    @user = User.new
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to users_path, notice: "You can't destroy yourself."
    else
      @user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(users_url) unless current_user.admin?
    end

    def signed_in_user_filter
      redirect_to root_path, notice: "Already logged in" if signed_in?
    end
end
