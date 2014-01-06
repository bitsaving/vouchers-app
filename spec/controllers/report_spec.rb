require 'spec_helper'
describe ReportsController do
  login_user
  before :each do   
    controller.stub(:authorize).and_return(true)
    request.env["HTTP_REFERER"] =  'http://test.host/'
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
    before do
      Voucher.stub(:check_validity).and_return(true)
      Voucher.stub(:convert_date).and_return(true)
    end
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
