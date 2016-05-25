class UserMailer < ActionMailer::Base
	default from: 'pintrest.share@gmail.com'
	def confirmation_instructions(user) 
		@user=user
		@rpt = @user.reset_password_token
		mail(to: @user.email, subject: 'Password reset instructions')
	end

	def send_user_data(user,password)
		@user=user
		@rpt = password
		mail(to: @user.email, subject: 'Password reset instructions')
	end
end