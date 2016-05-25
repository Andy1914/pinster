class PasswordsController < Devise::PasswordsController
	def create
		@user 	= User.find_by_email(params[:user][:email])
		@user.reset_password_token = generate_unique_reset_password
        @user.reset_password_sent_at = Time.now.utc
        @user.save(validate: false)
        UserMailer.confirmation_instructions(@user)  
		yield resource if block_given?

	    if successfully_sent?(resource)
	      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
	    else
	      respond_with(resource)
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
	def update
	    # self.resource = resource_class.reset_password_by_token(resource_params)
		    # render :json => params and return false
	    if params[:user][:reset_password_token].present?
	     	@user = User.find_by_reset_password_token(params[:user][:reset_password_token])
	     	if @user.persisted?
		          @user.password = params[:password]
		          # @user
			    yield @user if block_given?

			    if @user.errors.empty?
			      @user.unlock_access! if unlockable?(@user)
			      flash_message = @user.active_for_authentication? ? :updated : :updated_not_active
			      set_flash_message(:notice, flash_message) if is_flashing_format?
			      @user
			      sign_in(@user)
			      respond_with @user, location: after_resetting_password_path_for(@user)
			    else
			      respond_with @user
			    end
            else
            	flash[:notice]="invalid pin"
				respond_with @user
          	end

		else
			flash[:notice]="invalid pin"
			redirect_to "/	"
		end
	  end
end