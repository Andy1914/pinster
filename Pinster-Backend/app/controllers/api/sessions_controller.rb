class Api::SessionsController < Devise::SessionsController
  # DO not check for CSRF auth token when creating Session
  skip_before_action :verify_authenticity_token
   skip_before_filter :authenticate_user!, :except => [:destroy]
  respond_to :json

  def create
    @resource = User.find_by_email(params[:email])
    return invalid_login_attempt unless @resource

    if @resource.valid_password?(params[:password])
      if params[:token] && params[:platform]
        Devise.where(["token= ? AND platform = ? AND user_id != ?",params[:token],params[:platform],@resource.id] ).destroy_all
        @devices = @resource.devices.where(:token=>params[:token],:platform=>params[:platform]).first_or_create 
      end
      sign_in("user", @resource)
      # @resource.ensure_authentication_token
    else
      # render :json=>'nothing' and return false  
      return invalid_login_attempt
    end
  end

  def destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out" }
  end

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>"0", :message=>"Please check the credentials and try again"}, :status=>401
  end
end