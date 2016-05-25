class Contact < ActiveRecord::Base
	belongs_to :user
	belongs_to :user_contact,foreign_key: :contact_id,class_name: :User	 

	validates_presence_of :user_id,:contact_id

	REQUESTSTATUS={
	    1 => 'Requested',
	    2 => 'Pending',
	    3 => 'Accepted'
	}

	scope :pending, :conditions =>  "contacts.status is 1"
	scope :requested, :conditions =>  "contactships.status is 2"
	scope :accepted, :conditions =>  "contactships.status is 3"


end
