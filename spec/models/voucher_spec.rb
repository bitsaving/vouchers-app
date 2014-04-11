require 'spec_helper'
describe Voucher do
	before(:each) do
		@user = FactoryGirl.create(:user)
		@voucher = Voucher.create(:date => Date.today, :assignee_id => @user.id, :creator_id => @user.id)
		@transaction = Transaction.create(:voucher_id => @voucher.id, :payment_type => "cash", :payment_reference => "12345", :transaction_type => "debit", :amount => 100, :account_id => "2")
	  @comment =  FactoryGirl.create(:comment, voucher_id: @voucher.id, :description => "Accepted")

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
				  @comment  = @comment
				end
				it 'ensure association' do
					@voucher.comments << @comment
					expect(@comment.voucher_id).to eq @voucher.id
				end	
			end
		end
	end

	describe 'Instance Methods' do 
    describe '#accept' do 
      it 'should set the vouchers state to accepted' do 
        expect(@voucher.accept(@user)).to eq true
      end
    end

     describe '#reject' do 
      it 'should set the vouchers state to rejected and assigned to to nil' do 
        expect(@voucher.reject(@user)).to eq  true
      end
    end
    describe '#archive' do 
      it 'should set the vouchers state to archived' do 
        expect(@voucher.archive).to eq true
      end
    end
    describe '#approve' do 
      it 'should set the vouchers state to approved' do 
        expect(@voucher.approve(@user)).to eq true
      end
    end
    describe '#send for approval' do 
      it 'should set the vouchers state to pending' do 
        expect(@voucher.send_for_approval).to eq true
      end
    end

    describe '#assignee?' do 
      it 'determines whther the voucher is assigned to the desired person' do 
        expect(@voucher.assignee?(@user)).to eq true
      end
    end

    describe '#can_be_edited?' do 
      it 'determines whther the voucher can be edited or nots' do 
        expect(@voucher.can_be_edited?(@user)).to eq true
      end
    end
    describe '#can_be_commented?' do 
      it 'determines whther the voucher can be commented or not' do 
        expect(@voucher.can_be_commented?).to eq false
      end
    end

     describe '#check_if_destroyable?' do 
      it 'determines whther the voucher can be destroyed or not' do 
        expect(@voucher.check_if_destroyable).to eq true
      end
    end
      describe '#check_current_state and take necessary action' do 
      it 'determines the voucher current state and accordingl takes the action' do 
        expect(@voucher.change_state(@user, 'drafted')).to eq true
        expect(@voucher.change_state(@user, 'rejected')).to eq true
        expect(@voucher.change_state(@user, 'pending')).to eq true
        expect(@voucher.change_state(@user, 'increment')).to eq true
        expect(@voucher.change_state(@user, 'increment')).to eq true
       
        expect(@voucher.change_state(@user, 'archived')).to eq true
        
      end
    end

    describe '#amount' do 
      it 'is used to calculate the total amount' do 
        expect(@voucher.amount).to eq 100
      end
    end
  end

  describe  'class methods' do
    describe 'including_accounts_and_transactions' do
      it 'is used to include account and transactions' do
        expect(Voucher.including_accounts_and_transactions).to eq Voucher.where(workflow_state: 'drafted')
      end
    end
  end

end
