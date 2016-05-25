class Api::ContactsController < Api::ApplicationController
	def index
		@contacts  = current_user.contacts_of
	end

	# def contact_request    
	#     current_user.add_contact(params[:requested_to_id].to_i)
	#     @c_user = User.find_by_id(params[:requested_to_id].to_i)
	# end

	def change_status
	    @request_sent=Contact.find_by_user_id_and_contact_id(params[:user_id],params[:friend_id])
	    @request=Contact.find_by_user_id_and_contact_id(params[:friend_id],params[:user_id])
	    if params[:status] == '3'
	      @request.status = 3
	      @request_sent.status = 3 
	      @request.save
	      @request_sent.save    
	    else
	      @request_sent.delete
	      @request.delete
	    end	    
	    if params[:status] == '3'
	    	render :json => { :success => '1',:message => 'Contact request accepted successfully',:data=>[]}
	    else
	    	render :json => { :success => '1',:message => 'Contact request rejected successfully',:data=>[]}
	    end
	end
end