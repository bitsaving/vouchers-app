class User < ActiveRecord::Base
  acts_as_paranoid
  
  include PublicActivity::Common
  include DisplayConcern
  
  paginates_per 50
  
  devise :database_authenticatable, :omniauthable,
    :recoverable, :rememberable, :trackable, :omniauth_providers => [:google_oauth2]
  #FIXME_AB: Please ensure proper code formatting. space after comma. Space after comma not before comma.
  #fixed
  validates :first_name, :last_name, :email, presence: true
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => EMAIL_FORMAT
  before_validation :strip_blanks
 
  has_many :vouchers, :foreign_key => "creator_id", :dependent => :destroy
  has_many :assigned_vouchers, :foreign_key => "assignee_id", :class_name => "Voucher"
  has_many :comments, :dependent => :destroy
 
  default_scope { order('updated_at desc') }
 
  def self.from_omniauth(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
  end

  def admin?
    user_type == "admin"
  end

  def name
    first_name + " " + last_name
  end

  def getNotifications
    notifications = PublicActivity::Activity.where('owner_id = ? and visited = false', id).order('id desc').count
    if notifications > 0
      notifications
    else
     ""
    end 
  end
end