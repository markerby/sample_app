class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      #redirect_to user <- old code - automatically redirects to user's show page
      redirect_back_or user 
      #new code - friendly forwarding to the user's location at which they logged in
      #if no location, redirect to user's show page
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
      #render text: 'invalid combo'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
  
  #redirect_back_or and store_location are for friendly forwarding 
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to) 
    #delete the forwarding url otherwise the user would be redirected to that URL upon
    #every signin until they closed their browser 
  end

  def store_location
    session[:return_to] = request.url
  end
  
end

