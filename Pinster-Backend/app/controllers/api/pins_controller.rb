class Api::PinsController < Api::ApplicationController
	include ApplicationHelper
  # before_filter :authenticate_user!
  def index
    @user = User.find_by_id(params[:user_id])
  	@pins = @user.pins.sort.reverse
  end

  def received_pins
    @user = User.find_by_id(params[:user_id])
    @pins = SharedPin.where(:contact_id=>@user.id).map{|x| x.pin} 
  end


  def add_pin
    params[:latitude] = params[:latitude].to_f if params[:latitude]
    params[:longitude] = params[:longitude].to_f if params[:longitude]
    params[:category_id] = params[:category_id].to_i if params[:category_id]
    params[:friend_mobile_numbers] = params[:friend_mobile_numbers].split(',') if params[:friend_mobile_numbers].present?
    params[:friend_uids] = params[:friend_uids].split(',') if params[:friend_uids].present?
    params[:shared_picture] = params[:shared_picture] if params[:shared_picture].present?
    @pin = User.find(params[:user_id].to_i).pins.new(pin_params)
  	if @pin.save
      @mobile_ref = params[:friend_mobile_numbers].present? ? params[:friend_mobile_numbers] : []
      @fb_ref = params[:friend_uids].present? ? params[:friend_uids] : []
      groupname = params[:groupname].present? ? params[:groupname] : ''
      group_ids = params[:group_ids].present? ? params[:group_ids].split(',') : []
      pin_share_by_reference(params[:user_id],@pin.id,@mobile_ref,@fb_ref,params[:groupname],group_ids) if (@mobile_ref.count + @fb_ref.count)>0
      # pin_share_by_uid(params[:user_id],params[:friend_uids],@pin.id) if params[:friend_uids].present?
  		@message = "created successfully"
      @success = "1" 
  	else
  		@errors= @pin.errors.full_messages.collect{|x| x}.join('<br/>').html_safe
      render :json => { :success => '0',:message => @errors}
  	end
  end

  def show
  	@pin = Pin.find(params[:id].to_i)
  	# render :json => params and return false
  end

  def pin_likes
    @pin = Pin.find_by_id(params[:pin_id].to_i)
    @pin_like = @pin.pin_likes.where(:user_id=>params[:user_id].to_i).first_or_create
    if @pin_like.update_attributes(pin_like_params)
      @message = "pin like is updated successfully"
      @success = '1'
      render :json => {:message=>@message,:success=>@success,:data=>""}
    else
    end
  end

  def share_this_pin
    @pin = Pin.find_by_id(params[:pin_id].to_i)
    @mobile_ref = params[:friend_mobile_numbers].present? ? params[:friend_mobile_numbers] : []
    @fb_ref = params[:friend_uids].present? ? params[:friend_uids] : []
    groupname = params[:groupname].present? ? params[:groupname] : ''
    group_ids = params[:group_ids].present? ? params[:group_ids].split(',') : []
    pin_share_by_reference(params[:user_id],@pin.id,@mobile_ref,@fb_ref,params[:groupname],group_ids) if (@mobile_ref.count + @fb_ref.count)>0
    if @pin.user.shared_pins.map{|x| x.contact.id}.count > 0 
      @pin.status = 1
      @pin.save
    end
    @message = "Share updated successfully"
    @success = "1" 
  end
  
  private 

  def pin_params
    params.permit(:title, :user_id, :longitude, :latitude,:shared_picture, :category_id,:location,:status,:created_at,:message)
  end

  def pin_like_params
    params.permit(:pin_id,:user_id,:status)
  end

end
