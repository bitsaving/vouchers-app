require 'spec_helper'
describe VouchersController do
    login_user
    @current_user  = @user
     before :each do   
    controller.stub(:authorize).and_return(true)
    controller.stub(:set_i18n_locale_from_params).and_return(true)

    request.env["HTTP_REFERER"] =  'http://test.host/'
   # @current_user = FactoryGirl.create(:user)
    default_tab = "drafted"

#     @request.env["devise.mapping"] = Devise.mappings[:user]
#      #@user = FactoryGirl.create(:user)
#       sign_in FactoryGirl.create(:user,first_name: "divya",last_name: "talwar" ,email: "divya@vinsol.com")
# #controller.stub :current_user => @user
   

  end
  describe "get user" do

   it "should have a current_user" do
    # note the fact that I removed the "validate_session" parameter if this was a scaffold-generated controller
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
    #let(:voucher) { voucher = mock_model(Voucher).as_null_object }
    before(:each) do
      voucher = FactoryGirl.create(:voucher)      
            
      #Voucher.stub(:).and_return(voucher)
      #Voucher.stub(:find).and_return(voucher)
      get :show , :id => voucher.id
    end
    it "assigns voucher" do
     
      assigns[:voucher].should_not be_nil
    end
    it "displays the voucher" do
     # get :show ,:id => voucher.id
           expect(response).to render_template("show")
    end
  end
  describe "GET edit" do
    #let(:voucher) { voucher = mock_model(Voucher).as_null_object }
    before(:each) do
      @voucher = FactoryGirl.create(:voucher)      

      #controller.stub(:current_user){ FactoryGirl.create(:user)   }

      #@user = FactoryGirl.create(:user)
      #Voucher.stub(:).and_return(voucher)
      #Voucher.stub(:find).and_return(voucher)
       # get :edit , :id => @voucher.id
       #@current_user = mock_model(User, :id => 1)
 # @current_user.user_type = "admin"
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

  # describe "Get all vouchers" do
  #  it "assigns @vouchers" do
  #     get :all
  #     assigns(:vouchers).should_not be_nil
  #   end

  #   it "renders the index template" do
  #     get :all
  #     expect(response).to render_template("index")
  #   end
  # end
  #  describe "Get assigned vouchers" do
  #  it "assigns @vouchers" do
  #     get :assigned
  #     assigns(:vouchers).should_not be_nil
  #   end

  #   it "renders the assigned template" do
  #     get :assigned
  #     expect(response).to render_template("assigned")
  #   end
  # end
  # describe "vouchers edit" do
  #   before do
  #     @voucher = FactoryGirl.create(:voucher)
  #   end
  #   context "when voucher is found" do
  #     # before do
  #     #  Voucher.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
  #     # end
  #    it "renders the edit template" do
  #     get :edit ,:id => @voucher.id
  #     expect(response).to render_template("edit")
  #   end
  # end

#end
   describe "Voucher Destroy" do
    before do
      @voucher = FactoryGirl.create(:voucher)
    end

    # def delete_destroy_request
    #   delete :destroy, id: @user.id
    # end

    context "when voucher is found" do
      before do
       Voucher.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
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

    # def post_create_request(attributes = attributes_for(:user))
    #   post :create, { user: attributes }
    # end

    it "call the new method" do
      Voucher.should_receive(:new).and_return(@voucher)
      get :new
      assigns(:voucher).should == @voucher
    end
    it 'user should call save' do
      Voucher.should_receive(:new).and_return(@voucher)
      @voucher.should_receive(:save).and_return(@voucher)
     post :create , {voucher: FactoryGirl.attributes_for(:voucher) ,:format => :js}
    end

    context 'when saved' do
      before do
        post :create , {voucher: FactoryGirl.attributes_for(:voucher),:format => :js}
      end

      it 'should redirect to show' do
        get :show , id: @voucher.id
        response.should render_template("show")
      end
      # it 'should set flash notice' do
      #   flash[:notice].should eq('Voucher #' + @voucher.id.to_s + ' was successfully created.')
      # end
    end

    context 'when not saved' do
      before do
          post :create , {voucher: {date: nil} ,:format => :js }
      end

      it 'should render new' do
        response.should render_template "shared/_error_messages"
      end

    end
  end
 # describe "Get all vouchers"
 describe 'Post Update' do
    before do
     @voucher = FactoryGirl.create(:voucher)
    end

    # def patch_update_request(contact = "123423500")
    #   patch :update, { id: @user.id, user: { contact: contact, password: "secret", password_confirmation: "secret" } }
    # end


    context "when voucher is found" do
      before do
        Voucher.stub(:find_by).with(id: "#{@voucher.id}",:includes  => [:voucher_with_debit_from, :voucher_with_credit_to, :voucher_with_debited_transactions, :voucher_with_credited_transactions]).and_return(@voucher)
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
end