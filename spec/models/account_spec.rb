require 'spec_helper'
describe Account do
  before(:each) do
    @account = FactoryGirl.create(:account)
  end
  describe 'Instance Methods' do 
    describe '#prevent_destroy' do 
      it 'should prevent destroy of account' do 
        expect(@account.prevent_destroy).to eq false
      end
    end

     describe '#delete' do 
      it 'should prevent deletion of account' do 
        expect(@account.delete).to eq false
      end
    end
  end
  describe '#CLASS METHODS' do
    describe '#get_autocomplete_suggestions(term)' do
      it 'is expected to get the get_autocomplete_suggestions' do
        expect(Account.get_autocomplete_suggestions("fd")).to eq []
      end
    end
  end
end