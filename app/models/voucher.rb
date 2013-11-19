#FIXME_AB: Make sure approved_at and accepted_at are saved with vouchers, I think right now only one is being saved. Cross check
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
  accepts_nested_attributes_for :uploads , update_only: true , reject_if: proc { |attributes| attributes['bill_attachment'].blank? } , allow_destroy: true
  accepts_nested_attributes_for :comments , allow_destroy: true , update_only: true , reject_if: proc { |attributes| attributes['description'].blank? }
  #FIXME_AB: This method should be called check_if_destroyable
  before_destroy :check_voucher_state

  def record_state_change(user_id)
    comments.create!(description: workflow_state, user_id: user_id)
  end

  def approve(user_id)
     update_attributes(approved_by: user_id)
  end

  #FIXME_AB: Rejected vouchers should also be deletable. Does following condition handle this too?
  def check_voucher_state
    current_state < :approved
  end

  #FIXME_AB: Please add comments for these callback methods. We discussed it
  def accept(user_id)
    update_attributes({accepted_by: user_id , accepted_at: Time.now})
  end
  
  def reject(user_id)
    #FIXME_AB: Space after comma
    update_attributes({accepted_by: nil ,approved_by: nil})
  end

  def approve
    #FIXME_AB: Instead of Time.now you should use Time.zone.now or Time.current. Read the difference
    update_attributes({approved_at: Time.now })
  end

  def assignee?(user_id)
    assignee_id == user_id
  end

  def creator?(user_id)
    creator_id == user_id
  end
  
  def can_be_edited?
    #FIXME_AB: Instead of comparing the state we can use "new? || rejected?"
    current_state == :new || current_state == :rejected
  end

  def can_be_commented?
    current_state >= :pending && current_state < :accepted
  end

  end
