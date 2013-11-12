class Voucher < ActiveRecord::Base 
  include PublicActivity::Common
  include Workflow
  workflow_column :workflow_state
  workflow do
    state :new do
      event :send_for_approval,:transitions_to=> :pending
    end
    state :pending do
      event :approve, :transitions_to => :approved
      event :reject, :transitions_to => :rejected
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
  PAYMENT_TYPES = [ "Cash" , "Check", "Credit card", "Bank transfers" ]
  has_many :comments,:dependent=>:destroy
  validates :date,:payment_type,:amount ,presence: true
  validates :account_credited,:account_debited ,:presence=>true,:on => :create
  validates :to_date, :date => { :after_or_equal_to => :from_date,
    :message => 'must be after start date of project'} ,:allow_blank=> true

  validates :amount, numericality: { greater_than: 0.01}
  belongs_to :debit_from, :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to, :class_name => 'Account', :foreign_key => "account_credited"
  belongs_to :assigned_to ,:class_name =>'User',:foreign_key=>"assignee_id"
  belongs_to :creator ,:class_name => "User"
  belongs_to :approved ,:class_name => 'User', :foreign_key => "approved_by"
  belongs_to :accepted ,:class_name => 'User', :foreign_key => "accepted_by"
  has_many :uploads ,dependent: :destroy
  accepts_nested_attributes_for :uploads, update_only: true , reject_if: proc { |attributes| attributes['avatar'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true,reject_if: proc { |attributes| attributes['description'].blank? }
  def add_comment(user_id)
    comments.create!(description: workflow_state,user_id: user_id)
  end
  def approve(user_id)
     update_attributes(approved_by: user_id)
  end
  def accept(user_id)
     update_attributes(accepted_by: user_id)
  end
  def reject(user_id)
    update_attributes({accepted_by: nil ,approved_by: nil})
  end
end