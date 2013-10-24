class Voucher < ActiveRecord::Base 
    include Workflow
    workflow_column :workflow_state
    workflow do
      state :initial do
        event :create, :transitions_to => :new
      end
      state :new do
        event :send_for_approval,:transitions_to=> :pending
      end
      state :pending do
        event :review, :transitions_to => :being_reviewed
      end
      state :being_reviewed do
        event :approved, :transitions_to => :approved
        event :reject, :transitions_to => :rejected
      end
      state :approved do
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

    def update_vouchers_status
      self.create!
    end

end
