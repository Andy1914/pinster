class Twillo
	require 'twilio-ruby' 

	def self.send_message_through_twilio(mobile,body)
		@client = Twilio::REST::Client.new ACOUNT_SID, ACCOUNT_TOKEN 
		begin
			a = @client.account.messages.create({:from => '+16466792370', :to => mobile.to_s.gsub('-',''), :body => body.to_s}) 
			return a
	  	rescue Exception => e
	  		return e.message
		end
		
	end
end