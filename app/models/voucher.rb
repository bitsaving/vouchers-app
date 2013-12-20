class Voucher < ActiveRecord::Base 
  include PublicActivity::Common
  include Workflow
  acts_as_taggable
  workflow_column :workflow_state
  paginates_per 50
  workflow do
    state :drafted do
      event :send_for_approval, :transitions_to => :pending
    end
    state :pending do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
    end
    state :approved do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted do
      event :archive, :transitions_to => :archived
    end

    state :rejected do
      event :send_for_approval, :transitions_to => :pending
    end
    state :archived
  end

  PAYMENT_TYPES = [ "Cash" , "Cheque", "Credit card", "Bank transfers" ]

  validates :to_date, :date => { :after_or_equal_to => :from_date ,
    :message => 'must be after start date of project'}, :allow_blank=> true
  validates :date,  presence: true
  #validates :account_credited, :account_debited, :presence => { :message =>" by this name does not exist"}
  #validates :amount, numericality: { greater_than: 0.00 }
 
  validate :check_debit_credit_equality

  #belongs_to :debit_from , :class_name => 'Account', :foreign_key => "account_debited"
  #belongs_to :credit_to , :class_name => 'Account', :foreign_key => "account_credited"
  has_many :transactions
  has_many :debit_from, -> { where(:transactions => { account_type: "debit" }) } ,through: :transactions,source: :account
  has_many :credit_to  , -> {  where(:transactions => { account_type: "credit"}) },through: :transactions,source: :account
  
  #has_many :accounts, through: :transactions
  with_options :class_name =>'User' do |assoc|
    assoc.belongs_to :assignee
    assoc.belongs_to :creator
    assoc.belongs_to :approved_by_user, :foreign_key => "approved_by"
    assoc.belongs_to :accepted_by_user,:foreign_key => "accepted_by"
  end
  # belongs_to :assignee, :class_name =>'User'
  # belongs_to :creator, :class_name => "User"
  # belongs_to :approved_by_user, :class_name => 'User', :foreign_key => "approved_by"
  # belongs_to :accepted_by_user, :class_name => 'User', :foreign_key => "accepted_by"
   with_options :dependent => :destroy do |assoc|
    assoc.has_many :comments
    assoc.has_many :attachments 
  end
  # has_many :comments, :dependent => :destroy
  # has_many :attachments, :dependent => :destroy
  accepts_nested_attributes_for :attachments, update_only: true, reject_if: proc { |attributes| attributes['bill_attachment'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :transactions, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true, reject_if: proc { |attributes| attributes['description'].blank? }
  
  default_scope { order('date desc') }
  scope :drafted , -> { where(workflow_state: 'drafted') }
  scope :pending , -> { where(workflow_state: 'pending')}
  scope :approved , -> { where(workflow_state: 'approved')}
  scope :accepted , -> { where(workflow_state: 'accepted')}
  scope :rejected , -> { where(workflow_state: 'rejected')}
  scope :archived , -> { where(workflow_state: 'archived')}


  before_destroy :check_if_destroyable
 # before_destroy :remove_associated_tags
  #before_create :check_debit_credit_equality

  # def remove_associated_tags
  #   taglist = Voucher.tagged_with(tag_list)
  #   if taglist.blank?
  #     tags.delete_all
  #   end
  # end

  def check_debit_credit_equality
    debit_amount = total_amount("debit")
    credit_amount = total_amount("credit")
    if credit_amount != debit_amount
      errors.add :voucher ,"debited and credited amounts does not match.Please make sure that they are equal."
      return false
    end
  end



  def record_state_change(user_id)
    comments.create!(description: workflow_state.capitalize, user_id: user_id)
  end

  def check_if_destroyable
    current_state == :drafted || current_state == :rejected
  end

  #FIXME_AB: Please add comments for these callback methods. We discussed it
  #It is a callback for event "accept" which gets called once we invoke the event.
  def accept(user)
    update_attributes({accepted_by: user, accepted_at: Time.zone.now})
  end
  
  def reject(user_id)
    update_attributes({ accepted_by: nil, approved_by: nil })
  end


  def approve(user)
    #FIXME_AB: I would prefer Time.current
    update_attributes({approved_by: user, approved_at: Time.zone.now })
  end


  def assignee?(user)
    assignee_id == user.id
  end

  def creator?(user)
    creator_id == user.id
  end
  
  def can_be_edited?
    drafted? || rejected?
  end

  def can_be_commented?
    current_state >= :pending && current_state < :accepted
  end

  def total_amount(type)
    sum = 0
    self.transactions.reject! { |n| n.account_id.blank? }.select {|n| n.account_type == type }.each do |transaction|
      # if !transaction.account_id.blank?
       sum = sum + transaction.amount #if transaction.account_type == type 
      end
    # end
    sum
  end
end
