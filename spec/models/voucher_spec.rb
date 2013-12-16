require 'spec_helper'
describe Voucher do
	before(:each) do
		@voucher = Voucher.new(:date => Date.today,:payment_type => "Cheque" ,:payment_reference => "abcd",:amount => "100",:debit_from => mock_model("Account"),:credit_to => mock_model("Account"))
	end
	it "is valid with valid attributes" do
		@voucher.should be_valid
	end
	it "is invalid without date" do
		@voucher.date = nil
		@voucher.should_not be_valid
	end
	it "is invalid without payment type" do
		@voucher.payment_type = nil
		@voucher.should_not be_valid
	end
	it "is invalid without payment reference" do
		@voucher.payment_reference = nil
		@voucher.should_not be_valid
	end
	context 'When payment mode is cheque ' do 
		it 'is invalid without payment reference' do  
			@voucher.payment_type = "Cheque"
			@voucher.payment_reference = nil
			@voucher.should_not be_valid
		end
	end
	context 'When payment mode is cash ' do
		it 'is valid without payment reference' do 
			@voucher.payment_type = "Cash"
			@voucher.payment_reference = nil
			@voucher.should be_valid
		end
	end
	it "is invalid without debit account" do
		@voucher.account_debited = nil
		@voucher.should_not be_valid
	end 
	it "is invalid without credit account" do
		@voucher.account_credited = nil
		@voucher.should_not be_valid
	end 


	describe 'Associations' do 
		describe 'Attachment' do 
			context 'when attachment is associated' do
				before do 
					@attachment  = Attachment.new(bill_attachment_file_name: "abc", bill_attachment_content_type: 'application/pdf',bill_attachment_file_size:'71213',bill_attachment_updated_at: '2013-12-01 11:47:51')
				end
				it 'ensure association' do
					@voucher.attachments << @attachment
					expect(@attachment.voucher_id).to eq @voucher.id
				end
			end
		end
		describe 'Comment' do 
			context 'when comment is associated' do
				before do 
				  @comment  = Comment.new(description: "hii test comment")
				end
				it 'ensure association' do
					@voucher.comments << @comment
					expect(@comment.voucher_id).to eq @voucher.id
				end	
			end
		end
	end
end
