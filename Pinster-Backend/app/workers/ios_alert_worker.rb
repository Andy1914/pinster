class IosAlertWorker
  include Sidekiq::Worker

  # Sidetiq should schedule this job every half hour between 08:30 - 16:30 every Monday-Friday.
  # Note: The job will be queued at this time, not executed.
  # Set the Sidekiq Queue to 'ios_alert_worker_queue', enable backtrace logging, and retry if the job fails
  sidekiq_options :queue => :ios_alert_worker_queue, backtrace: true, retry: true

  def perform(user_id,pin_id,device_tokens)
    # Keep the connection to gateway.push.apple.com open throughout the duration of this job
    pusher = Grocer.pusher(
      certificate: "#{Rails.root}/app/workers/cert.pem",      # required
      passphrase:  "123456",                       # optional
      gateway:     "gateway.sandbox.push.apple.com", # optional
      port:        2195,                     # optional
      retries:     10                         # optional
    )

    # User.find.joins(:device).where('devices.platform = ?', 'ios').pluck('devices.token').each do |token|
    device_tokens.each do |token|
      notification = Grocer::Notification.new(
        device_token:      token,
        alert:             "You Got A Pin Share",
        custom: { "acme2" => ["user_id"=>user_id.to_s, "pin_id"=>pin_id.to_s] }
      )
      pusher.push(notification)
    end
  end
end