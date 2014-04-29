OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 722007704487042 , "5ee1dd5b1528be6cefad9f493880df55"
end
