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
    state :accepted
    state :rejected do
      event :send_for_approval, :transitions_to => :pending
    end
  end

  PAYMENT_TYPES = [ "Cash" , "Cheque", "Credit card", "Bank transfers" ]

  default_scope { order('date desc') }
  scope :drafted , -> { where(workflow_state: 'drafted') }
  scope :pending , -> { where(workflow_state: 'pending')}
  scope :approved , -> { where(workflow_state: 'approved')}
  scope :accepted , -> { where(workflow_state: 'accepted')}
  scope :rejected , -> { where(workflow_state: 'rejected')}
 
  validates :to_date, :date => { :after_or_equal_to => :from_date ,
    :message => 'must be after start date of project'}, :allow_blank=> true
  validates :date, :payment_type, :amount, presence: true
  validates :account_credited, :account_debited, :presence => { :message =>" by this name does not exist"}
  validates :amount, numericality: { greater_than: 0.00 }
  validates :payment_reference, :presence  => { :message =>" cannot be blank" }, :unless => Proc.new { |a| a['payment_type'] == "Cash" }

  belongs_to :debit_from , :class_name => 'Account', :foreign_key => "account_debited"
  belongs_to :credit_to , :class_name => 'Account', :foreign_key => "account_credited"
  belongs_to :assignee, :class_name =>'User', :foreign_key=>"assignee_id"
  belongs_to :creator, :class_name => "User"
  belongs_to :approved_by_user, :class_name => 'User', :foreign_key => "approved_by"
  belongs_to :accepted_by_user, :class_name => 'User', :foreign_key => "accepted_by"
  has_many :comments, :dependent => :destroy
  has_many :attachments, dependent: :destroy
  accepts_nested_attributes_for :attachments, update_only: true, reject_if: proc { |attributes| attributes['bill_attachment'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :comments, allow_destroy: true, update_only: true, reject_if: proc { |attributes| attributes['description'].blank? }
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

  def check_if_destroyable
    current_state == :drafted || current_state == :rejected
  end

  #FIXME_AB: Please add comments for these callback methods. We discussed it
  #It is a callback for event "accept" which gets called once we invoke the event.
  def accept(user)
    update_attributes({accepted_by: user, accepted_at: Time.zone.now})
  end
  
  def reject(user_id)
    update_attributes({accepted_by: nil, approved_by: nil})
  end


  def approve(user)
    #FIXME_AB: Instead of Time.now you should use Time.zone.now or Time.current. Read the difference
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

end
