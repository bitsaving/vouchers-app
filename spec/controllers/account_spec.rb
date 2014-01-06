require_relative '../spec_helper'

describe AccountsController do
   login_user
    @current_user  = @user
    before :each do   
    request.env["HTTP_REFERER"] =  'http://test.host/'
    controller.stub(:authorize).and_return(true)
  end
  describe "GET Index" do
    before do
      @account = FactoryGirl.create(:account,name: "abc")
    end

    it "assigns @accounts" do
      get :index
      expect(assigns(:accounts).first).to eq @account
    end

    it "should render index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'Get New' do
    before do
     @account = FactoryGirl.create(:account,name: "abc")
    end

    it "should call account's new" do
      Account.should_receive(:new).and_return(@account)
      get :new
      expect(assigns(:account)).to eq @account
    end
    it "should render new template" do
      get :new
      expect(response).to render_template :new
    end
    it "has a 200 status code" do
      get :new
      expect(response.status).to eq(200)
    end
  end
  describe 'Get Show' do
    before do
      @account = FactoryGirl.create(:account,name: "abc")
    end

    context "when account is found with Id" do
      before do
       get :show, id: @account.id
      end
      it "should assign @account" do
        expect(assigns(:account)).to eq(@account)
      end
      it "should render show template" do
        response.should render_template :show
      end
      it "has a 200 status code" do
        expect(response.status).to eq(200)
      end
    end
    context "when account in not found with Id" do
      before do
        @account.id = 0
        get :show, id: @account.id
      end
      it "should redirect accounts Index" do
        response.should redirect_to request.env["HTTP_REFERER"]
      end
      it "should has a alert message" do
        expect(flash[:alert]).to eq("You are not authorized to view the requested page")
      end
      it "has a 302 status code" do
        expect(response.status).to eq(302)
      end
    end
  end

  describe 'Post Create' do
    before do 
      @account = FactoryGirl.create(:account, name: "abc")
    end

    it "should call account's new" do
      Account.should_receive(:new).and_return(@account)
      post :create , {account: FactoryGirl.attributes_for(:account) }
    end
    it 'account should call save' do
      Account.should_receive(:new).and_return(@account)
      @account.should_receive(:save).and_return(true)
      post :create , {account: FactoryGirl.attributes_for(:account) }
    end

    context 'when saved' do
      before do
       post :create , {account: FactoryGirl.attributes_for(:account),:format => :html }
      end

      it 'should redirect to new' do
        response.should be_redirect 
      end
    end

    context 'when unsaved' do
      before do
        post :create , { account: {name: "" }}
      end

      it 'should render new' do
        response.should render_template :new
      end
    end
  end

  describe 'Post Update' do
    before do
      @account = FactoryGirl.create(:account)
    end

    context "when account found with id" do
      before do
        Account.stub(:find_by).with(id: "#{@account.id}").and_return(@account)
      end
      it "should call update" do
        @account.should_receive(:update).and_return(@account)
        patch :update , { id: @account.id ,  account: { name: "divya1"}}
      end
      context 'when successfully update attributes' do
        before do
           patch :update , { id: @account.id ,  account: { name: "divya1"}}
        end

        it 'should redirect to show page' do
          response.should be_redirect 
        end
        it 'should have response code 302' do
          response.code.should eq('302')
        end
      end

      context 'when not successfully update attributes' do
        before do
          patch :update , { id: @account.id ,  account: { name: ""}}
        end

        it 'should render new' do
          response.should render_template :edit
        end
        it 'should have response code 200' do
          response.code.should eq('200')
        end
        it 'should have errors' do
          @account.errors.count > 1
        end
      end
    end

    context "when account in not found with Id" do
      before do
        @account.id = 0
         patch :update , { id: @account.id ,  account: { name: "divya1"}}
      end
      it "should redirect accounts Index" do
        response.should redirect_to request.env["HTTP_REFERER"]
      end

      it "has a 302 status code" do
        expect(response.status).to eq(302)
      end
    end
  end
  describe "Account destroy" do
   
      before do
        @account = FactoryGirl.create(:account)
        Account.stub(:find_by).with(id: "#{@account.id}").and_return(@account)
      end
      
      it "should call destroy" do
        @account.stub(:destroy).and_return(@account)
      end

      context 'should not destory account' do
         before do
          @account.stub(:destroy).and_return(false)
        end
        it 'should have errors' do
          @account.errors.count > 1
        end
      end
    end

    describe 'get autocomplete_suggestions'  do
      before do
        @account = FactoryGirl.create(:account, name: "abcd")
        get :autocomplete_suggestions, :term => "abc"
        Account.stub(:get_autocomplete_suggestions).and_return(@account)
        #
      end

      it "should render json content" do
        
        @account.should_not render_template("new")
      end
    end


  # end
end