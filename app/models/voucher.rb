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

  

  validates :to_date, :date => { :after_or_equal_to => :from_date,
    :message => 'must be after start date of project' }, :allow_blank => true
  validates :date,  presence: true
  validate :check_debit_credit_equality
  
  has_many :transactions

  has_many :debited_transactions, -> { where(:transactions => { transaction_type: "debit" })}, :class_name => 'Transaction'
  has_many :credited_transactions, -> { where(:transactions => { transaction_type: "credit" }) }, :class_name => 'Transaction'
  
  has_many :debit_from, -> { where(:transactions => { transaction_type: "debit" }) }, through: :transactions, source: :account
  has_many :credit_to, -> { where(:transactions => { transaction_type: "credit" }) }, through: :transactions, source: :account
  
  with_options :class_name => 'User' do |user|
    user.belongs_to :assignee
    user.belongs_to :creator
    user.belongs_to :approved_by_user, :foreign_key => "approved_by"
    user.belongs_to :accepted_by_user, :foreign_key => "accepted_by"
  end

  with_options :dependent => :destroy do |voucher|
    voucher.has_many :comments
    voucher.has_many :attachments 
  end

  accepts_nested_attributes_for :attachments, update_only: true, reject_if: proc { |attributes| attributes['bill_attachment'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :transactions, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true, reject_if: proc { |attributes| attributes['description'].blank? }
  
  default_scope { order('date desc') }

  scope :drafted, -> { where(workflow_state: 'drafted') }
  scope :pending, -> { where(workflow_state: 'pending') }
  scope :approved, -> { where(workflow_state: 'approved') }
  scope :accepted, -> { where(workflow_state: 'accepted') }
  scope :rejected, -> { where(workflow_state: 'rejected') }
  scope :archived, -> { where(workflow_state: 'archived') }
  scope :not_accepted, -> { where.not(workflow_state: 'accepted') }
  
  scope :assignee, ->(id) { where(assignee_id: id) }
  scope :created_by, ->(id) { where(creator_id: id) }
  
  scope :by_account, ->(id) { joins(:transactions).where(:transactions => {:account_id => id })}
  scope :by_transaction_type, ->(type) { joins(:transactions).where(:transactions => {:transaction_type => type })}
  
  scope :between_dates, ->(from, to) { where('date between (?) and (?)', from, to) }
  
  before_destroy :check_if_destroyable

  def self.including_accounts_and_transactions
    includes(:debit_from, :credit_to, :debited_transactions, :credited_transactions)
  end
  
  def check_debit_credit_equality
    debit_amount = total_amount("debit")
    credit_amount = total_amount("credit")
    if credit_amount != debit_amount
      errors.add :voucher, "debited and credited amounts does not match.Please make sure that they are equal."
    end
  end

  def check_if_destroyable
    drafted? || rejected?
  end

  #It is a callback for event "accept" which gets called once we invoke the event.

  def accept(user)
    update_attributes({ assignee_id: user.id, accepted_by: user.id, accepted_at: Time.zone.now})
    comments.create( description: "Accepted", user_id: user.id )
  end

  def archive
    update_attributes({ assignee_id: nil })
  end
  
  def reject(user)
    update_attributes({ accepted_by: nil, approved_by: nil, assignee_id: creator_id })
    comments.create( description: "Rejected", user_id: user.id )
  end

  def amount
    sum = 0
    debited_transactions.each do | voucher|
      sum += voucher.amount
    end
    sum
  end

  def approve(user)
    #FIXME_AB: I would prefer Time.current
    #fixed
    update_attributes({ approved_by: user.id, approved_at: Time.current })
  end

  def send_for_approval
    update_attributes(updated_at: Time.current)
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
    self.transactions.reject { |n| n.account_id.blank? }.select {|n| n.transaction_type == type }.each do |transaction|
       sum = sum + transaction.amount
      end
    sum
  end

  def increment_state(user)
    case "#{current_state}"
      when "rejected" then send_for_approval!
      when "drafted" then send_for_approval!
      when "pending" then approve!(user)
      when "approved" then accept!(user)
      when "accepted" then archive!
    end 
  end

  def decrement_state(user)
    case "#{current_state}"
      when "pending" then reject!(user)
      when "approved" then reject!(user)
    end
  end

end
