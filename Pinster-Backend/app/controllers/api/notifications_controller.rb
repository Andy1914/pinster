class Api::NotificationsController < Api::ApplicationController
	def notifications
		@notifications = []
		@notifications << Contact.where(:contact_id=>params[:user_id].to_i,:status=>2).map{|x| ["#{x.user.name.present? ? x.user.name : "" } wants to connect with you",'1',x.updated_at,x.user.id]}.compact
		@notifications << PinLike.where(:user_id=>params[:user_id].to_i).each.map{|x| ["#{x.try(:user).try(:name)} liked your pin #{x.try(:pin).try(:title)}",'2',x.created_at] }.compact
		@notifications << SharedPin.where(:contact_id=>params[:user_id].to_i).each.map{|x| ["#{x.try(:user).try(:name).present? ? x.try(:pin_share).try(:name) : ''} has shared a pin #{x.pin.location}",'3',x.created_at,x.try(:pin_share).try(:id)]}.compact	
		@user_notification = @notifications[0].compact.sort_by{|x| x[2]}
		y  = {}
		@notifie = @user_notification.each_with_index do |x, i|
			y[i] = x
		end
		# render :json => @notifie and return false
		# @notifie = @user_notification.each_with_index.map{|x,i| [i,x]}
	end
end