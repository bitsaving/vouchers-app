class OmniAuth::SessionsController < Devise::SessionsController
  skip_before_action :authorize
  skip_before_action :store_location
end