require 'spec_helper'
describe Voucher do
	before(:each) do
		@voucher = Voucher.create(:date => Date.today)
		@transaction = Transaction.create(:voucher_id => @voucher.id,:payment_type => "cash" ,:payment_reference => "12345", :transaction_type => "debit",:amount =>100, :account_id => "2")
	end
	it "is valid with valid attributes" do
		@voucher.should be_valid
	end
	it "is invalid without date" do
		@voucher.date = nil
		@voucher.should_not be_valid
	end
	it "is invalid without payment type" do
		@transaction.payment_type = nil
		@transaction.should_not be_valid
	end
	context 'When payment mode is cheque ' do 
		it 'is invalid without payment reference' do  
			@transaction.payment_type = "Cheque"
			@transaction.payment_reference = nil
			@transaction.should_not be_valid
		end
	end
	context 'When payment mode is cash ' do
		it 'is valid without payment reference' do 
			@transaction.payment_type = "Cash"
			@transaction.payment_reference = nil
			@transaction.should be_valid
		end
	end
	it "is invalid without debit account" do
		@transaction.account_id = nil
		@transaction.transaction_type = "debit"
		@transaction.should_not be_valid
	end 
	it "is invalid without credit account" do
		@transaction.account_id = nil
		@transaction.transaction_type = "credit"
		@transaction.should_not be_valid
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
