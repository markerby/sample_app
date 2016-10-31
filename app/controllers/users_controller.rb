class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  
  def new
  	@user = User.new
  end
  
  def show
    @user = User.find(params[:id]) #get pararams from URL
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    #@user = User.find(params[:id]) 
    #don't have to call the line above now because it is called in correct_user which is called before edit
  end
  
  def update
    #@user = User.find(params[:id])
    #don't have to call the line above now because it is called in correct_user which is called before update
    
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
	  sign_in @user #have to do this because the remember_token is reset on save whihc invalidates the session so have to sign them in again
	  redirect_to @user
    else
      render 'edit'
    end
  end
  
  def index
  	#@users = User.all
  	@users = User.paginate(page: params[:page]) #pulls out the users one chunk at a time
  end
  
 def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  
  private

    def signed_in_user
      unless signed_in?
        store_location #for friendly forwarding to their current location once they are signed in
        redirect_to signin_url, notice: "Please sign in."
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
