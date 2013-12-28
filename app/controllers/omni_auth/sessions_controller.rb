class OmniAuth::SessionsController < Devise::SessionsController
  skip_before_action :authorize
  before_action only: [:new] do
    flash[:notice] = nil

  end
end