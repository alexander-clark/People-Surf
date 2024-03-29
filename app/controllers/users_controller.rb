class UsersController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    
    if current_user.admin?
      if params[:type]
        @title = "All users | Search"
        @users = User.where("type = ?", "#{params[:type]}").paginate(:page => params[:page])
      else
        @title = "All users"
        @users = User.paginate(:page => params[:page])
      end
    elsif current_user.type == 1
      @title = "All Tutors"
      @users = User.where("type = ?", "2").paginate(:page => params[:page])
    else
      @title = "All Students"
      @users = User.where("type = ?", "1").paginate(:page => params[:page])
    end
  end
  
  def show
    @user = User.find(params[:id])
    @subjects = @user.subjects.find(:all)
  end
  
  def new
    @title = 'Sign up'
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to TutorSurf!"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @subs = @user.subject_ids
    @title = "Edit user"
  end
  
  def update
    params[:user][:subject_ids] ||= []
    @user = User.find(params[:id])
    @subs = @user.subject_ids
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
