Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, "252743831601148", "924c3e7045959005265fdf239278ec89"
end