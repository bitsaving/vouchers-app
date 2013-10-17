class UploadsController < ApplicationController
	before_action :authorize
	 def index
	 	@uploads = Upload.all
	 end
end
