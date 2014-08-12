class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :follwers]      #only index, edit and update actions are available if the user is signed_in_user.
  before_action :correct_user,   only: [:edit, :update]      #only edit and update actions are available if the user is correct_user.
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"     #define the @title here so it can be passed to views
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'    #rendering in the controller won't require a partial. This method will use the URL users/1/follwing with the "show_follow" template
  end

  def followers
    @title = "Followers"      #define the @title here so it can be passed to views
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'     #rendering in the controller won't require a partial. This method will use the URL users/1/follwers with the "show_follow" template
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)  #note :admin is not included here because the lis here is for permitted attributes
    end

      # Before filters
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
