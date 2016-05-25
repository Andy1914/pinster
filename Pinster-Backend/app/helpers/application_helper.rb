module ApplicationHelper
	def pin_share_by_reference(user_id,pin_id,mobile_numbers=[],uid = [],groupname,group_ids)
		@user= User.find(user_id)
		@contacts_to_invite = []
		@contact_to_share = []
		group_user_ids = Group.where(:id=>group_ids).pluck(:user_ids).join(',').split(',').compact.uniq.map(&:to_i)
		@mobile_users=User.where("mobile in (?) OR uid in (?) OR id in (?)",mobile_numbers,uid,group_user_ids)
		@contacts_to_share=@user.contacts.map{|x| x.user_contact}.map{|y| y if mobile_numbers.include?(y.mobile) || uid.include?(y.uid)}.compact
		@ext_mobile_number = @mobile_users.present? ? mobile_numbers - @mobile_users.pluck(:mobile) : mobile_numbers
		if groupname.present? and groupname.length>0
			# creating groups
			puts "groupname #{groupname}"
			Group.new(:owner_id=>@user.id,:user_ids=>@contacts_to_share.map{|x| x.id}.uniq.compact.join(','),:name=>groupname).save
		end
		#sharelist
		share_pin(@user,@contacts_to_share,pin_id.to_i) if @contacts_to_share.present?
		@devise_tokens_ios = @contacts_to_share.map{|x| x.devices.ios_tokens.pluck(:token) if x.push_notification==true}.uniq.compact
		IosAlertWorker.perform_async(@user.id,pin_id,@devise_tokens_ios) if @devise_tokens_ios.present?
		#invite to contact
		invite_contact(@user,@contacts_to_invite) if @contacts_to_invite.present?
		#app request through mobile
		invite_through_mobile_number(@user.name,@ext_mobile_number.compact) if @ext_mobile_number.compact.count > 0
	end	

	def invite_through_mobile_number(name,numbers=[])
	end


	# def pin_share_by_mobile(user_id,mobile_numbers=[],pin_id)
	# 	@user= User.find(user_id)
	# 	@contacts_to_invite = []
	# 	@contact_to_share = []
	# 	@mobile_users=User.where("mobile in (?)",mobile_numbers)
	# 	@contacts_to_share=@user.contacts.map{|x| x.user_contact}.map{|y| y if mobile_numbers.include?(y.mobile)}.compact
	# 	@contacts_to_invite = @mobile_users.present? ? (@mobile_users - @contact_to_share) : []
	# 	@ext_mobile_number = @mobile_users.present? ? mobile_numbers - @mobile_users.pluck(:mobile) : mobile_numbers
	# 	#sharelist
	# 	share_pin(@user,@contacts_to_share,pin_id.to_i) if @contacts_to_share.present?
	# 	@devise_tokens_ios = @contacts_to_share.map{|x| x.devices.ios_tokens.pluck(:token) if x.push_notification==true}.uniq.flattern.compact
	# 	IosAlertWorker.perform_async(@user.id,pin_id,devise_tokens) if @devise_tokens.present
	# 	#invite to contact
	# 	invite_contact(@user,@contacts_to_invite) if @contacts_to_invite.present?
	# 	#app request through mobile
	# end
	# def pin_share_by_uid(user_id,uid=[],pin_id)
	# 		@user= User.find(user_id)
	# 		@uid_users=User.where("uid in (?)",uid)
	# 		@contact_to_share=@user.contacts.map{|x| x.user_contact}.map{|y| y if uid.include?(y.uid)}.compact
	# 		@contacts_to_invite = @uid_users.present? ? @uid_users - @contact_to_share : [] 
	# 		@ext_uid_number = @uid_users.present? ? uid_numbers - @uid_users.pluck(:uid) : uid_numbers
	# 		# #sharelist
	# 		share_pin(@user,@contacts_to_share,pin_id) if @contacts_to_share.present?
	# 		@devise_tokens_ios = @contacts_to_share.map{|x| x.devices.ios_tokens.pluck(:token) if x.push_notification==true}.uniq.flattern.compact
	# 		IosAlertWorker.perform_async(@user.id,pin_id,devise_tokens) if @devise_tokens.present?
	# 		# #invite to contact
	# 		# invite_contact(@user,@contacts_to_invite) if @contacts_to_invite.present?
	# 	#app request through mobile
	# end

	def share_pin(user,contact_to_share,pin_id)
		@user = user
		contact_to_share.each do |x|
			@user.shared_pins.create(:pin_id=>pin_id,:contact_id=>x.id)
		end
	end

	def invite_contact(user,contacts_to_invite)
		@user = user
		contacts_to_invite.each do |x|
			@user.add_contact(x.id)
		end
	end
end
