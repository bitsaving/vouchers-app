#FIXME_AB: code formatting issue. Please put some spaces between methods
#Fixed
class Voucher < ActiveRecord::Base 
  include PublicActivity::Common
  include Workflow
  acts_as_taggable
  workflow_column :workflow_state
  workflow do
    state :new do
      event :send_for_approval , :transitions_to => :pending
    end
    state :pending do
      event :approve , :transitions_to => :approved
      event :reject , :transitions_to => :rejected
    end
    state :approved do
      event :accept , :transitions_to => :accepted
      event :reject , :transitions_to => :rejected
    end
    state :accepted
    state :rejected do
      event :send_for_approval , :transitions_to => :pending
    end
  end
  #FIXME_AB: Check => Cheque
  #Fixed
  PAYMENT_TYPES = [ "Cash" , "Cheque", "Credit card", "Bank transfers" ]
  #FIXME_AB: Vouchers in new, and pending states can be destroyed only. No other voucher should be deleted.
  #Fixed
  has_many :comments,:dependent => :destroy
  validates :date,:payment_type , :amount , presence: true
  validates :account_credited , :account_debited , :presence => {:message =>" by this name does not exist"}
  validates :to_date , :date => { :after_or_equal_to => :from_date ,
    :message => 'must be after start date of project'} , :allow_blank=> true

  #FIXME_AB: greater_than 0.00 something
  #Fixed
  validates :amount , numericality: { greater_than: 0.00}
  belongs_to :debit_from , :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to , :class_name => 'Account', :foreign_key => "account_credited"
  belongs_to :assigned_to , :class_name =>'User', :foreign_key=>"assignee_id"
  belongs_to :creator , :class_name => "User"
  belongs_to :approved , :class_name => 'User', :foreign_key => "approved_by"
  belongs_to :accepted , :class_name => 'User', :foreign_key => "accepted_by"
  has_many :uploads , dependent: :destroy
  #FIXME_AB: why avatar, its not avatar
  accepts_nested_attributes_for :uploads , update_only: true , reject_if: proc { |attributes| attributes['avatar'].blank? } , allow_destroy: true
  accepts_nested_attributes_for :comments , allow_destroy: true , update_only: true , reject_if: proc { |attributes| attributes['description'].blank? }
  before_destroy :check_voucher_state
  #FIXME_AB: Why this method named as add_comment. What it looks like is that it is recording the state change as comment so we can name it as record state change
  #Fixed
  def record_state_change(user_id)
    comments.create!(description: workflow_state, user_id: user_id)
  end

  #FIXME_AB: this is just setting approver's id, not doing anything with state. so we should name it as set_approver. same for accept and reject
  #cant change because these methods are the methoda provided with the same name as that of state when we implement state machine  and gets called themselves when state changes.
  def approve(user_id)
     update_attributes(approved_by: user_id)
  end

  def check_voucher_state
    current_state < :approved
  end

  def accept(user_id)
    update_attributes(accepted_by: user_id)
  end
  
  def reject(user_id)
    update_attributes({accepted_by: nil ,approved_by: nil})
  end

#  def tag_list
#   @voucher.tag_list if @voucher
#   end

# def tag_list=(name)
#   self.tag_list
# end
end