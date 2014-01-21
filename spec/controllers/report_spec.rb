require 'spec_helper'
describe ReportsController do
  login_user
  before :each do   
    controller.stub(:logged_in).and_return(true)
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
      # params: { @from =  "1/2/2013".to_date, @to = '2/3/2013'.to_date }
      controller.stub(:convert_date)
    end
    it "assigns @vouchers" do
      get :report, params: { from: @from, to: @to }
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :report, params: { from: @from, to: @to }
      expect(response).to render_template("index")
    end
  end
  
end
