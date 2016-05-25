class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_user_permitted_parameters,:only=>:update
  def create
    # render :json => sign_up_params and return false 
    build_resource(sign_up_params)
    
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        sign_in("user", resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def edit
    @user=current_user
  end

  def update
    # super 
    if (params[:user][:current_password]=="" || !params[:user][:current_password].present?) && !params[:user][:password].present?
      @user = User.find(current_user.id) 
      params[:user].delete(:current_password)
      # render :json => configure_permitted_parameters and return false
      @user.update_without_password(configure_user_permitted_parameters)

      # resource_updated = update_resource(resource, account_update_params)
      
      if @user.update_without_password(configure_user_permitted_parameters)
      
        sign_in @user, resource, bypass: true
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    else
      @user = User.find(current_user.id) 
      
      # render :json => configure_permitted_parameters and return false

      # resource_updated = update_resource(resource, account_update_params)
      
      if @user.update_with_password(configure_user_permitted_parameters)
      
        sign_in @user, resource, bypass: true
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end
  end

  protected

  def configure_user_permitted_parameters
    # devise_parameter_sanitizer.for(:sign_up).push(:name, :mobile, :date_of_birth)
    params.require(:user).permit(:name, :mobile, :password,:password_confirmation,:date_of_birth,:email,:current_password,:profile_picture)
  end

  def sign_up_params
    # devise_parameter_sanitizer.for(:sign_up).push(:name, :mobile, :date_of_birth)
    params.require(:user).permit(:name, :mobile, :password,:password_confirmation,:date_of_birth,:email,:profile_picture)
  end

  def after_sign_up_path_for(resource)
    "/"
  end
end