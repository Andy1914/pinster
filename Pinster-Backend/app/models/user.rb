class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	mount_uploader :profile_picture, ProfilePictureUploader
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # :omniauthable, :omniauth_providers => [:facebook]

 	has_many :contacts
 	has_many :pins

  has_many :shared_pins,dependent: :destroy
 	has_many :pin_add,through: :shared_pins
  has_many :devices
  has_many :groups
  
  validates_uniqueness_of :email
  validates_uniqueness_of :uid, :allow_nil => true, :allow_blank => true
  # validates_uniqueness_of :mobile,:uid, :allow_nil => true, :allow_blank => true
  # validate_presence_of :password, :allow_nil => true, :allow_blank => true

 	def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
    end
  end

 	def self.from_omniauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   # assuming the user model has a name
	    # user.image = auth.info.image # assuming the user model has an image
	  end
	end


  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def get_users_by_mobile(mobile)
    User.where(:mobile=>mobile)
  end

  def get_users_by_mobile(uid)
    User.where(:uid=>uid)
  end

  # def self.contacts
  #   User.contacts.user_contact      
  # end

  def add_contact(user)
    contact1 = contacts.where({:contact_id => user}).first_or_create    
    contact1.status=2
    if !contact1.save
    else
      co_contact = Contact.where({:user_id =>contact1.contact_id,:contact_id => contact1.user_id}).first_or_create    
      co_contact.status=1
      co_contact.save
    end
  end

  def contacts_of
    self.contacts.map{|x| x.user_contact}
  end

  def user_contacts
    self.contacts.where(:status=>3)
  end

  def remove_contact(user)
    contact = Contacts.find(:first, :conditions => ["user_id = ? and contact_id = ?", self.id, user.id])
    if contact
      contact.destroy
    end
  end

  def is_contact?(contact)
    return self.contacts.include? contact
  end

  def my_pins
    self.pins
  end

  
  def generate_default_code
    ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(6).join
  end 

  # def date_of_birth=(date_of_birth)
  #   if date_of_birth.instance_of?(String) && date_of_birth.match(/\d+\-\d+\-\d+/)
  #     year, month,day  = date_of_birth.split('-').map { |date| date.to_i }
  #     date_of_birth = Date.new(year, month, day)
  #   end
  #   write_attribute(:date_of_birth, date_of_birth)
  # end
  
  def set_reset_password_token
    raw, enc = '123123123'

    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
    raw
  end
end
