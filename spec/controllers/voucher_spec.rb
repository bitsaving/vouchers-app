require 'spec_helper'
describe VouchersController do
  login_user
  @current_user  = @user
  before :each do 
    controller.stub(:logged_in?).and_return(true)  
    controller.stub(:authorize).and_return(true)

    request.env["HTTP_REFERER"] =  'http://test.host/'
  end
  describe "get user" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
    end
  end
  
  describe "GET index" do
    it "assigns @vouchers" do
      get :index
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
  
  describe "GET new" do
    it "creates a voucher" do
     FactoryGirl.build(:voucher)
    end
    it "renders  the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET show" do
    before(:each) do
      voucher = FactoryGirl.create(:voucher)      
      get :show , :id => voucher.id
    end
    it "assigns voucher" do 
      assigns[:voucher].should_not be_nil
    end
    it "displays the voucher" do
      expect(response).to render_template("show")
    end
  end

  describe "GET edit" do
    before(:each) do
      @voucher = FactoryGirl.create(:voucher)      
      get :edit , :id => @voucher.id
    end

    it "assigns voucher" do
          assigns[:voucher].should_not be_nil
    end
    it "displays the voucher" do
          expect(response).to render_template("edit")
    end
  end
  
  describe "Get pending vouchers" do
   it "assigns @vouchers" do
      get :pending
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :pending
      expect(response).to render_template("index")
    end
  end
  
  describe "Get drafted vouchers" do
   it "assigns @vouchers" do
      get :drafted
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :drafted
      expect(response).to render_template("index")
    end
  end
  
  describe "Get approved vouchers" do
   it "assigns @vouchers" do
      get :approved
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :approved
      expect(response).to render_template("index")
    end
  end
  
  describe "Get accepted vouchers" do
   it "assigns @vouchers" do
      get :accepted
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :accepted
      expect(response).to render_template("index")
    end
  end
  
  describe "Get rejected vouchers" do
   it "assigns @vouchers" do
      get :rejected
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :rejected
      expect(response).to render_template("index")
    end
  end
  
  describe "Get archived vouchers" do
   it "assigns @vouchers" do
      get :archived
      assigns(:vouchers).should_not be_nil
    end

    it "renders the index template" do
      get :archived
      expect(response).to render_template("index")
    end
  end

  describe "Voucher Destroy" do
    before do
      @voucher = FactoryGirl.create(:voucher)
    end
    context "when voucher is found" do
      before do
       Voucher.stub(:including_accounts_and_transactions).and_return(@vouchers)
       @vouchers.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
      end
      
      it "should call destroy" do
        @voucher.should_receive(:destroy).and_return(@voucher)
        delete :destroy, id: @voucher.id
      end

      context 'when successfully destroyed' do
        before do
            delete :destroy, id: @voucher.id
        end

        it 'should redirect to index page' do
          response.should redirect_to request.env["HTTP_REFERER"]
        end
        it 'should set flash notice' do
          flash[:notice].should eq("Voucher #" + @voucher.id.to_s + " was deleted successfully")
        end
      end
      context 'when not Destroyed' do
        before do
          @voucher.stub(:destroy).and_return(false)
          delete :destroy, id: @voucher.id
        end

        it 'should redirect' do
          response.should redirect_to request.env["HTTP_REFERER"]
        end
        it 'should have errors' do
          @voucher.errors.count > 1
        end
      end
    end
  end


  describe 'Post Create' do
    before do 
      @voucher = FactoryGirl.create(:voucher)
    end

    it "call the new method" do
      Voucher.should_receive(:new).and_return(@voucher)
      get :new
      assigns(:voucher).should == @voucher
    end
    it 'user should call save' do
      Voucher.should_receive(:new).and_return(@voucher)
      @voucher.should_receive(:save).and_return(@voucher)
     post :create , {voucher: FactoryGirl.attributes_for(:voucher), :format => :js}
    end

    context 'when saved' do
      before do
        post :create , {voucher: FactoryGirl.attributes_for(:voucher), :format => :js}
      end

      it 'should redirect to show' do
        get :show , id: @voucher.id
        response.should render_template("show")
      end
    end

    context 'when not saved' do
      before do
          post :create , {voucher: {date: nil}, :format => :js }
      end

      it 'should render new' do
        response.should render_template "shared/_error_messages"
      end
    end
  end
  describe 'Post Update' do
    before do
     @voucher = FactoryGirl.create(:voucher)
    end

    context "when voucher is found" do
      before do
        Voucher.stub(:including_accounts_and_transactions).and_return(@vouchers)
       @vouchers.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
      end
      it "should call update" do
        @voucher.should_receive(:update).and_return(@voucher)
        patch :update , { id: @voucher.id , voucher: {date: Date.yesterday()} ,:format => :js}    
      end
      context 'when updation is successful' do
        before do
      patch :update , { id: @voucher.id , voucher: {date: Date.yesterday()},:format => :js }
        end

        it 'should redirect to show' do
        get :show , id: @voucher.id
        response.should render_template("show")
      end
        it 'should set flash notice' do
          flash[:notice].should eq("Voucher #" + @voucher.id.to_s + " was successfully updated")
        end
      end

      context 'when not successfully update attributes' do
        before do
          patch :update , { id: @voucher.id , voucher: {date: nil}, :format => :js}
        end

        it 'should render edit' do
          response.should render_template "shared/_error_messages"
        end
        it 'should have errors' do
          @voucher.errors.count > 1
        end
      end
    end
  end

  describe 'Post decrement' do
    before do
     @voucher = FactoryGirl.create(:voucher)
    end
    context "when voucher is found" do
      before do
        Voucher.stub(:including_accounts_and_transactions).and_return(@vouchers)
       @vouchers.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
      end
      it "should call change" do
        @voucher.stub(:change).and_return(@voucher)
         patch :decrement_state , { id: @voucher.id}
      end
      context 'when change is successful' do
        before do
          patch :decrement_state , { id: @voucher.id}    
        end
        it 'should redirect to index page' do
          response.should redirect_to voucher_path(@voucher)
        end
        it "should set flash message" do
          flash[:notice].should eq("Voucher #"  + @voucher.id.to_s + " rejected successfully and assigned back to " + @voucher.creator.name)
        end
      end
    end
  end
  describe 'Post increment' do
    before do
     @voucher = FactoryGirl.create(:voucher)
    end

    context "when voucher is found" do
      before do
        Voucher.stub(:including_accounts_and_transactions).and_return(@vouchers)
        @vouchers.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
      end
      it "should call change" do
        @voucher.stub(:change).and_return(@voucher)
        patch :increment_state , { id: @voucher.id, voucher: { assignee_id: @voucher.creator_id}}    
      end
      context 'when change is successful' do
        before do
          patch :increment_state , { id: @voucher.id, voucher: { assignee_id: @voucher.creator_id }}    
        end
        it 'should redirect to index page' do
          response.should redirect_to voucher_path(@voucher)
        end
      end
    end
  end
end

