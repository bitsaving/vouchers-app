require_relative '../spec_helper'

describe ApplicationController do
   login_user
    @current_user  = @user
    before :each do   
      controller.stub(:logged_in).and_return(true)
      request.env["HTTP_REFERER"] =  'http://test.host/'
      controller.stub(:authorize).and_return(true)
    end

    describe "authorize" do

      it "authorizes user" do

      expect(controller.stub(:authorize)).to eq true
    end

    # it "should render index template" do
    #   get :index
    #   expect(response).to render_template :index
    # end
  end

end