require_relative '../spec_helper'

describe CommentsController do
  login_user
  before :each do   
    request.env["HTTP_REFERER"] =  'http://test.host/'
    controller.stub(:authorize).and_return(true)
  end
  describe 'Post Create' do
    before do 
      @voucher = FactoryGirl.create(:voucher)
      Voucher.stub(:find_by).with(id: "#{@voucher.id}").and_return(@voucher)
      @comment = FactoryGirl.create(:comment,description: "abc", voucher_id: @voucher.id)
    end

    it "should call comment new" do
      Comment.should_receive(:new).and_return(@comment)
      post :create , { comment: FactoryGirl.attributes_for(:comment),voucher_id: @voucher.id }
    end
    it 'should call save' do
      Comment.should_receive(:new).and_return(@comment)
      @comment.should_receive(:save).and_return(true)
      post :create , {comment: FactoryGirl.attributes_for(:comment),voucher_id: @voucher.id }
    end

    context 'when saved' do
      before do
       post :create , {comment: FactoryGirl.attributes_for(:comment),voucher_id: @voucher.id,:format => :html }
      end

      it 'should redirect to new' do
        response.should redirect_to request.env["HTTP_REFERER"]
      end
    end

    context 'when unsaved' do
      before do
        post :create , { comment: FactoryGirl.attributes_for(:comment),voucher_id: @voucher.id, description: ""}
      end

      it 'should render new' do
        response.should be_redirect
      end
    end
  end
end