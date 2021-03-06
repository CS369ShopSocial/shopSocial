class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
      if (params[:value])
        @values = User.where("name ilike ?", "%#{params[:value]}%")
        @users = @values.paginate(page: params[:page])
      else
        @users = User.paginate(page: params[:page])
      end

  end

  def show
  	@user = User.find(params[:id])
  end

  def destroy
    if User.find(params[:id]) == current_user
        redirect_to root_url
    else

      @tempUser = User.find(params[:id])
      for friendship in (Friendship.where friend_id: @tempUser.id)
        friendship.destroy
      end     
      @tempUser.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end

  def new
    if signed_in?
      redirect_to root_url
    else
  	   @user = User.new
    end
  end
  def create
    if signed_in?
      redirect_to root_url
    else
    	@user = User.new(user_params)
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Shop Social!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                    :password_confirmation)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to root_url, notice: "Please sign in."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
