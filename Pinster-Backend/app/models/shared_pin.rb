class SharedPin < ActiveRecord::Base
	belongs_to :user
	belongs_to :pin
	belongs_to :pin_add,foreign_key: :pin_id,class_name: :Pin
	belongs_to :pin_share,foreign_key: :contact_id,class_name: :User
end
