#FIXME_AB: Make sure approved_at and accepted_at are saved with vouchers, I think right now only one is being saved. Cross check
#fixed
class Voucher < ActiveRecord::Base 
  include PublicActivity::Common

  include Workflow
  
  acts_as_taggable
  workflow_column :workflow_state
  paginates_per 3
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
  #fixed
  default_scope { order('date desc') }
  scope :New , -> { where(workflow_state: 'new') }
  scope :pending , -> { where(workflow_state: 'pending')}
  scope :approved , -> { where(workflow_state: 'approved')}
  scope :accepted , -> { where(workflow_state: 'accepted')}
  scope :rejected , -> { where(workflow_state: 'rejected')}
 
  validates :to_date , :date => { :after_or_equal_to => :from_date ,
    :message => 'must be after start date of project'} , :allow_blank=> true
  validates :date,:payment_type , :amount , presence: true
  validates :account_credited , :account_debited , :presence => {:message =>" by this name does not exist"}
  validates :amount , numericality: { greater_than: 0.00}
  #FIXME_AB: Why :New not :new
  #new is a reserved word

  belongs_to :debit_from , :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to , :class_name => 'Account', :foreign_key => "account_credited"
  #FIXME_AB: Better if we name it as assignee
  #fixed
  belongs_to :assignee , :class_name =>'User', :foreign_key=>"assignee_id"
  belongs_to :creator , :class_name => "User"
  belongs_to :approved_by_user , :class_name => 'User', :foreign_key => "approved_by"
  belongs_to :accepted_by_user , :class_name => 'User', :foreign_key => "accepted_by"
  has_many :comments,:dependent => :destroy
  has_many :attachments , dependent: :destroy
  accepts_nested_attributes_for :attachments , update_only: true , reject_if: proc { |attributes| attributes['bill_attachment'].blank? } , allow_destroy: true
  accepts_nested_attributes_for :comments , allow_destroy: true , update_only: true , reject_if: proc { |attributes| attributes['description'].blank? }
  #FIXME_AB: This method should be called check_if_destroyable
  #fixed
  before_destroy :check_if_destroyable
  before_destroy :remove_associated_tags

  def remove_associated_tags
    taglist = Voucher.tagged_with(tag_list)
    if taglist.blank?
      tags.delete_all
    end
  end


  def record_state_change(user_id)
    comments.create!(description: workflow_state.capitalize, user_id: user_id)
  end

  #FIXME_AB: Rejected vouchers should also be deletable. Does following condition handle this too?
  #fixed
  def check_if_destroyable
    current_state == :new || current_state == :rejected
  end

  #FIXME_AB: Please add comments for these callback methods. We discussed it
  #It is a callback for event "accept" which gets called once we invoke the event.
  def accept(user)
    update_attributes({accepted_by: user , accepted_at: Time.zone.now})
  end
  
  def reject(user_id)
    #FIXME_AB: Space after comma
    #fixed
    update_attributes({accepted_by: nil , approved_by: nil})
  end


  def approve(user)
    #FIXME_AB: Instead of Time.now you should use Time.zone.now or Time.current. Read the difference
    update_attributes({approved_by: user , approved_at: Time.zone.now })
  end


  def assignee?(user)
    assignee_id == user.id
  end

  def creator?(user)
    creator_id == user.id
  end
  
  def can_be_edited?
    #FIXME_AB: Instead of comparing the state we can use "new? || rejected?"
    current_state == :new || current_state == :rejected
  end

  def can_be_commented?
    current_state >= :pending && current_state < :accepted
  end

  end
