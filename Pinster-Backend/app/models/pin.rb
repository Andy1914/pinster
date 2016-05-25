class Pin < ActiveRecord::Base
	mount_uploader :shared_picture, SharedPictureUploader
	has_many :pin_likes
	belongs_to :category
	belongs_to :user

	has_many :shared_pins,dependent: :destroy
	has_many :pin_share,through: :shared_pins

	def is_liked?(user_id)
		self.pin_likes.pluck(&:contact_id).include?(user_id.to_i)
	end

	def pin_like_users
		pin_likes.map{|x| x.user}
	end
end
