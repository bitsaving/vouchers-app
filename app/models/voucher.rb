class Voucher < ActiveRecord::Base 
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
  include Workflow
  workflow_column :workflow_state
  workflow do
    state :new do
      event :send_for_approval,:transitions_to=> :pending
<<<<<<< HEAD
    end
    state :pending do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
=======
    end
    state :pending do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
=======
    include Workflow
    #FIXME_AB: Is there any specific reason to have custom column name. Can't we name the column as state
    workflow_column :workflow_state
    workflow do
      #FIXME_AB: I think we need not to have this state. As the first state defined would be the default state. So if we have 'new' as a first state then it would be the default state
      state :initial do
        event :create, :transitions_to => :new
      end
      state :new do
        event :send_for_approval,:transitions_to=> :pending
      end
      #FIXME_AB: I think we can avoid having being_reviewed state. Directly move to approved or rejected from pending
      state :pending do
        event :review, :transitions_to => :being_reviewed
      end
      state :being_reviewed do
        #FIXME_AB: Event should be approve and state should be approved
        event :approved, :transitions_to => :approved
        event :reject, :transitions_to => :rejected
      end
      state :approved do
        #FIXME_AB: Event should be accept and state should be accepte
        event :approved, :transitions_to => :accepted
        event :reject, :transitions_to => :rejected
      end
      state :accepted
      state :rejected
    end

    PAYMENT_TYPES = [ "Check", "Credit card", "Bank transfers","Cash" ]
    has_many :comments
    validates :date,:from_date,:to_date,:pay_type,:amount ,presence: true
    validates :debit_from_id,:credit_to_id ,:presence=>true,:on => :create
    validates :to_date, :date => {:after_or_equal_to => :from_date,
      :message => 'must be after start date of project'}
    validates :amount, :numericality => true
    belongs_to :debit_from, :class_name => 'Account'
    belongs_to :credit_to, :class_name => 'Account'
    belongs_to :assigned_to ,:class_name=>'User'
    belongs_to :user
    has_many :uploads ,dependent: :destroy
    accepts_nested_attributes_for :uploads, allow_destroy: true, update_only: true 
    accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true
    after_commit :update_vouchers_status, :on => :create

    #FIXME_AB: I think this method would not be required once we change states/workflows
    def update_vouchers_status
      self.create!
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
    end
    state :approved do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected do
      event :send_for_approval ,:transitions_to => :pending
    end
  end
  PAYMENT_TYPES = [ "Check", "Credit card", "Bank transfers","Cash" ]
  has_many :comments
  validates :date,:payment_type,:amount ,presence: true
  validates :account_credited,:account_debited ,:presence=>true,:on => :create
  validates :to_date, :date => {:after_or_equal_to => :from_date,
    :message => 'must be after start date of project'}
  validates :amount, numericality: { greater_than: 0.01}
  belongs_to :debit_from, :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to, :class_name => 'Account', :foreign_key => "account_credited"
  belongs_to :assigned_to ,:class_name=>'User',:foreign_key=>"assignee_id"
  belongs_to :creator ,:class_name=> "User"
  has_many :uploads ,dependent: :destroy
  accepts_nested_attributes_for :uploads, allow_destroy: true, update_only: true , reject_if: proc { |attributes| attributes['avatar'].blank? }
  accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true,reject_if: proc { |attributes| attributes['description'].blank? }
end
