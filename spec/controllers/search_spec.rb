require 'spec_helper'
require 'rake'
VoucherApp::Application.load_tasks

describe SearchesController do
  login_user
  @current_user  = @user
   before :each do   
    Rake::Task["ts:start"].invoke
    controller.stub(:authorize).and_return(true)
    request.env["HTTP_REFERER"] =  'http://test.host/'
  end
   after(:each) do
    Rake::Task["ts:stop"].invoke
  end

  describe "GET search results" do
    it "assigns @vouchers" do
      get :search, :query => "abc"
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
     get :search, :query => "abc"
      expect(response).to render_template("vouchers/_vouchers")
    end
  end
  
end
