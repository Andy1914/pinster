class Device < ActiveRecord::Base
	scope :ios_tokens, -> { where(platform: 'ios') }
	scope :android_tokens, -> { where(platform: 'android') }
end
