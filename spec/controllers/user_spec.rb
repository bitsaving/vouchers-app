require_relative '../spec_helper'

describe Admin::UsersController do
  login_user
  before :each do   
    request.env["HTTP_REFERER"] =  'http://test.host/admin'
    controller.stub(:authorize).and_return(true)
  end
  describe "GET Index" do
    before do
      @user = FactoryGirl.create(:user, email: "abc@vinsol.com", first_name: "abc",last_name: "cde")
    end

    it "assigns @users" do
      get :index
      expect(assigns(:users).first).to eq @user
    end
    it "should render index template" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'Get New' do
    before do
      @user = FactoryGirl.build(:user,email: "abc@vinsol.com", first_name: "abc",last_name: "cde")
    end

    it "should call User's new" do
      User.should_receive(:new).and_return(@user)
      get :new
      expect(assigns(:user)).to eq @user
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
      @user = FactoryGirl.create(:user,email: "abc@vinsol.com", first_name: "abc",last_name: "cde")
    end

    context "when User is found with Id" do
      before do
       get :show, id: @user.id
      end
      it "should assign @user" do
        expect(assigns(:user)).to eq(@user)
      end
      it "should render show template" do
        response.should render_template :show
      end
      it "has a 200 status code" do
        expect(response.status).to eq(200)
      end
    end
    context "when User in not found with Id" do
      before do
        @user.id = 0
        get :show, id: @user.id
      end
      it "should redirect Users Index" do
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
      @user = FactoryGirl.create(:user, email: "abc@vinsol.com", first_name: "abc",last_name: "cde", user_type: "normal")
    end


    it "should call User's new" do
      User.should_receive(:new).and_return(@user)
      post :create , {user: FactoryGirl.attributes_for(:user) }
    end
    it 'user should call save' do
      User.should_receive(:new).and_return(@user)
      @user.should_receive(:save).and_return(true)
      post :create , {user: FactoryGirl.attributes_for(:user) }
    end

    context 'when saved' do
      before do
       post :create , {user: FactoryGirl.attributes_for(:user) , :format => :html }
      end

      it 'should redirect to show' do
         get :show , id: @user.id
        response.should render_template("show")
      end
    end

    context 'when unsaved' do
      before do
        post :create , {user: FactoryGirl.attributes_for(:user), first_name: "" }
      end

      it 'should render new' do
        response.should render_template :new
      end
      it 'should have response code 200' do
        response.code.should eq('200')
      end
    end
  end

  describe 'Post Update' do
    before do
      @user = FactoryGirl.create(:user,email: "abc@vinsol.com", first_name: "abc",last_name: "cde")
    end


    context "when user found with id" do
      before do
        User.stub(:find_by).with(id: "#{@user.id}").and_return(@user)
      end
      it "should call update" do
        @user.should_receive(:update).and_return(@user)
        patch :update , { id: @user.id ,  user: { first_name: "divya1"}}
      end
      context 'when successfully update attributes' do
        before do
           patch :update , { id: @user.id ,  user: { first_name: "divya1"}}
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
          patch :update , { id: @user.id ,  user: { first_name: ""}}
        end

        it 'should render new' do
          response.should render_template :edit
        end
        it 'should have response code 200' do
          response.code.should eq('200')
        end
        it 'should have errors' do
          @user.errors.count > 1
        end
      end
    end

    context "when User in not found with Id" do
      before do
        @user.id = 0
         patch :update , { id: @user.id ,  user: { first_name: "divya1"}}
      end
      it "should redirect Users Index" do
        response.should redirect_to request.env["HTTP_REFERER"]
      end
      it "has a 302 status code" do
        expect(response.status).to eq(302)
      end
    end
  end

  describe "User destroy" do
   
      before do
        @user = FactoryGirl.create(:user, :email => "abcd@vinsol.com")
        User.stub(:find_by).with(id: "#{@user.id}").and_return(@user)
      end
      
      it "should call destroy" do
        @user.stub(:destroy).and_return(@user)
        delete :destroy, id: @user.id
      end

      context 'should not destory ' do
         before do
          @user.stub(:destroy).and_return(false)
          delete :destroy, id: @user.id
        end
        it 'should redirect' do
          @user.should redirect_to admin_users_path
        end
      end
    end

end