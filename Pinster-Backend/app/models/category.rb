class Category < ActiveRecord::Base
	mount_uploader :icon, IconUploader
	has_many :pins

	validates_uniqueness_of :name

end
