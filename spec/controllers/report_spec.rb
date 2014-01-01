require 'spec_helper'
describe ReportsController do
    login_user
    @current_user  = @user
     before :each do   
    controller.stub(:authorize).and_return(true)
    controller.stub(:set_i18n_locale_from_params).and_return(true)

    request.env["HTTP_REFERER"] =  'http://test.host/'
   # @current_user = FactoryGirl.create(:user)
    # default_tab = "drafted"

#     @request.env["devise.mapping"] = Devise.mappings[:user]
#      #@user = FactoryGirl.create(:user)
#       sign_in FactoryGirl.create(:user,first_name: "divya",last_name: "talwar" ,email: "divya@vinsol.com")
# #controller.stub :current_user => @user
   

  end
   describe "GET reports" do
    it "assigns @vouchers" do
      get :report
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
     get :report
      expect(response).to render_template("index")
    end
  end
  describe "Post generate report" do
    it "assigns @vouchers" do
      get :report
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
     get :report
      expect(response).to render_template("index")
    end
  end
end
