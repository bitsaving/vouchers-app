#FIXME_AB: code formatting issue. Please put some spaces between methods
#Fixed
#FIXME_AB: Voucher should also have approved_at and accepted_at datetime column which should be updated on their respective actions[Just in db, not to display on frontend for now]
#fixed
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

  PAYMENT_TYPES = [ "Cash" , "Cheque", "Credit card", "Bank transfers" ]

  #FIXME_AB: Validations and association are mixed together. For better maintainability and readability you should group them together. Like all validations first then associations.
  has_many :comments,:dependent => :destroy
  validates :date,:payment_type , :amount , presence: true
  validates :account_credited , :account_debited , :presence => {:message =>" by this name does not exist"}
  #FIXME_AB: Why :New not :new
  scope :New , -> { where(workflow_state: 'new').order('updated_at desc') }
  validates :to_date , :date => { :after_or_equal_to => :from_date ,
    :message => 'must be after start date of project'} , :allow_blank=> true

  validates :amount , numericality: { greater_than: 0.00}
  belongs_to :debit_from , :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to , :class_name => 'Account', :foreign_key => "account_credited"
  #FIXME_AB: Better if we name it as assignee
  belongs_to :assigned_to , :class_name =>'User', :foreign_key=>"assignee_id"
  belongs_to :creator , :class_name => "User"
  #FIXME_AB: Since :approved and :accepted returns user who did the action. Shouldn't we name them as approved_by and accepted_by
  belongs_to :approved , :class_name => 'User', :foreign_key => "approved_by"
  belongs_to :accepted , :class_name => 'User', :foreign_key => "accepted_by"
  has_many :uploads , dependent: :destroy
  #FIXME_AB: why avatar, its not avatar
  accepts_nested_attributes_for :uploads , update_only: true , reject_if: proc { |attributes| attributes['avatar'].blank? } , allow_destroy: true
  accepts_nested_attributes_for :comments , allow_destroy: true , update_only: true , reject_if: proc { |attributes| attributes['description'].blank? }
  #FIXME_AB: This method should be called check_if_destroyable
  before_destroy :check_voucher_state

  def record_state_change(user_id)
    comments.create!(description: workflow_state, user_id: user_id)
  end

  #FIXME_AB: this is just setting approver's id, not doing anything with state. so we should name it as set_approver. same for accept and reject
  #cant change because these methods are the methods provided with the same name as that of state when we implement state machine  and gets called themselves when state changes.
  def approve(user_id)
     update_attributes(approved_by: user_id)
  end

  #FIXME_AB: Rejected vouchers should also be deletable. Does following condition handle this too?
  def check_voucher_state
    current_state < :approved
  end

  def accept(user_id)
    update_attributes(accepted_by: user_id)
  end
  
  def reject(user_id)
    update_attributes({accepted_by: nil ,approved_by: nil})
  end

  def assignee?(user_id)
    assignee_id == user_id
  end
  
  def can_be_commented?
    current_state >= :pending && current_state < :accepted
  end

  end
