class OmniauthCallbacksController < ApplicationController
	def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # auth = request.env["omniauth.auth"]
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(request.env["omniauth.auth"])
    # render :json => user and return false
    # session[:user_id] = user.id
    # redirect_to root_url, :notice => "Signed in!"
  
    # render :json => user and return false

    if @user.persisted?
    	session[:user_id] = @user.id
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      # set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end