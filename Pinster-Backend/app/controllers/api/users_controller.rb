class Api::UsersController < Api::ApplicationController
include CarrierWave::MiniMagick
  # before_filter :skip_trackable
  before_filter :configure_permitted_parameters,:only=>[:user_create,:update_user]

  def show_current_user	
    if !current_user
      render :status => 401,
             :json => { :success => '0',
                        :message => "Auth failed" }
    end
  end

  def send_reset_pasword
	  @user = User.find_by_email(params[:email])
    # render :json => params and return false
		if @user.present?
			# @user  = User.find_by_email(params[:user][:email])
      # @user.reset_password_token = generate_unique_reset_password
      # @user.reset_password_sent_at = Time.now.utc
      password = generate_unique_reset_password
      @user.password = password
      @user.save(validate: false)
      UserMailer.send_user_data(@user,password).deliver!
			render :json => { :success => "1",
                        :message => "Reset password instructions sent to your email" }
		else
		  render :json => { :success => '0',
                        :message => "Email is not matched with our records" }
		end
	end	

  def generate_unique_reset_password(pas = '')
    @oldpass = User.all.pluck(:reset_password_token).uniq.compact
    pass = ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join
    if @oldpass.include?(pass) || pass == ''
      generate_unique_reset_password(pass)
    else
      return pass
    end       
  end

  def reset_password_by_token
    @user = User.find_by_reset_password_token(params[:user][:reset_password_token])
    if @user.persisted?
      if params[:password].present?
        @user.password = params[:password] 
        @user.save
        sign_in(@user)
        render :json => { :success => "1",
                        :message => "Password reset scessfull" }
      else
        render :json => { :success => '0',
                        :message => "Please enter the password" }
      end
    else
      render :json => { :success => '0',
                        :message => "Email is not matched with our records" }
    end
  end

	def user_create
		# if params[:user][:profile_picture]
		# 	configure_user_permitted_parameters[:user][:profile_picture] = parse_image_data(configure_user_permitted_parameters[:profile_picture]) if configure_user_permitted_parameters[:profile_picture].present?	
		# end

    if params[:mobile].present?
      params[:mobile_code] = generate_default_code
      params[:mobile_verification_status] = 'pending'
    end

		params[:password_confirmation] ||= params[:password]
    @user = User.new(configure_permitted_parameters)
    # render :json => params and return false 
    # @user.build_subscription(:package_id=>params[:package_id])
    if @user.save
      if params[:token] && params[:platform]
        Devise.where(["token= ? AND platform = ?",params[:token],params[:platform]] ).destroy_all
        @devices = @user.devices.where(:token=>params[:token],:platform=>params[:platform]).first_or_create 
      end
      sign_in(@user)
      @message = "user created successully"
      @success = "1"
    else
      @errors= @user.errors.full_messages.collect{|x| x}.uniq.join('<br/>').html_safe
      # @a = params.except!(*['action','controller','password_confirmation','formate'])
      # render :json => a and return false
      render :json => { :success => '0',:message => @errors,:data=>params.except(*['action','controller','password_confirmation','format'])}
    end
  end

  def update_user
    params[:notification]=params[:notification] == '1' ? 1 :0 if params[:notification]
    params[:push_notification]=params[:push_notification] == '1' ? 1 :0 if params[:push_notification]
  	params[:password_confirmation] ||= params[:password] if params[:password]
    @user = User.find(params[:user_id])
    params[:notification] = params[:notification] == '0' ? false : true if params[:notification].present?
    unless params[:password]
      if @user.update_without_password(configure_permitted_parameters)
        @message = "updated successfully"
        @success = "1" 
      else
        @errors= @user.errors.full_messages.collect{|x| x}.join('<br/>').html_safe
        render :json => { :success => '0',:message => @errors,:data=>params.except(*['action','controller','password_confirmation','format'])}
      end
    else
      if @user.update(configure_permitted_parameters)
        @message = "updated successfully"
        @success = "1" 
      else
        @errors= @user.errors.full_messages.collect{|x| x}.join('<br/>').html_safe
        render :json => { :success => '0',:message => @errors,:data=>params.except(*['action','controller','password_confirmation','format'])}
      end
    end
  end
  
  def mobile_verification
    @user = User.find(params[:user_id])
    if params[:mobile_code] == @user.mobile_code
      @user.mobile_verification_status = true
      @user.save
      render :json => { :success => '1',:message => "Mobile verified successfully"}
    else
      render :json => { :success => '0',:message => "please check the code and please try again"}
    end
  end

  def update_mobile
    @user = User.find(params[:user_id])#User.find_by_id(params[:id].to_i) 
    if params[:mobile].present?
      # if params[:mobile][0] != '+' 
      #   params[:mobile] = params[:mobile].prepend('+')
      # else
      #   params[:mobile] = params[:mobile][0]
      # end
      # render :json => params[:mobile] and return false
      params[:mobile_code] = generate_default_code
      params[:mobile_verification_status] = false
    end
    if @user.update_without_password(configure_permitted_parameters)
      x = Twillo.send_message_through_twilio(@user.mobile,"Your Pinster code is #{@user.mobile_code} . Enjoy !")
      @message = "mobile updated successfully"
      @success = "1" 
      @message_from_twillo = x

    else
      @errors= @user.errors.full_messages.collect{|x| x}.join('<br/>').html_safe
      render :json => { :success => '0',:message => @errors,:data=>params.except(*['action','controller','password_confirmation','format'])}
    end
  end

  def facebook_login
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    # auth = request.env["omniauth.auth"]
    params[:provider]||='facebook'
    @user = User.where(:email=>params[:email],:provider=>params[:provider],:uid=>params[:uid]).first_or_create
    params[:notification]=params[:notification] == '1' ? 1 :0 if params[:notification].present?
    params[:push_notification]=params[:push_notification] == '1' ? 1 :0 if params[:push_notification].present?
    @user.password = Devise.friendly_token[0,20]
    # render :json => @user.errors and return false
    if @user.update_attributes(facebook_params)
      if params[:token] && params[:platform]
        Devise.where(["token= ? AND platform = ? AND user_id != ?",params[:token],params[:platform],@user.id] ).destroy_all
        @devices = @user.devices.where(:token=>params[:token],:platform=>params[:platform]).first_or_create 
      end
      session[:user_id] = @user.id
      sign_in(@user)      
      @message = "user signed in successully"
      @success = "1"
    else
      render :json => {:success=>'0',:message=>'User creation failed'}
    end
  end
  
  def user_groups
    @groups = Group.where(owner_id: params[:user_id].to_i)
    # render :json => @groups and return false
    @groups_data = @groups.map{|x| [:id => x.id,:name => x.name]}.flatten
    render :json => {:success=>'1',:message=>'',:data=>@groups_data}
    
  end
  protected

  def configure_permitted_parameters
    params.permit(:name, :mobile, :mobile, :email, :password, :password_confirmation,:profile_picture,:date_of_birth,:mobile_code,:mobile_verification_status ,:notification,:push_notification)
  end

  def configure_user_permitted_parameters
    params.require(:user).permit(:name, :mobile, :mobile, :email, :password, :password_confirmation,:profile_picture,:date_of_birth,:mobile_code,:mobile_verification_status ,:notification,:push_notification)
  end

  def generate_default_code
    ([*('0'..'9')]-%w(0 1 I O)).sample(6).join
  end

  def facebook_params
    params.permit(:name, :mobile, :email,:date_of_birth,:mobile_verification_status,:notification,:push_notification)
  end

end