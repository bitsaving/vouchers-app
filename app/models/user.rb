class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  include DisplayConcern
  default_scope { order('updated_at desc') }
  paginates_per 50
  has_many :notifications, -> { order 'created_at desc' }, :class_name => "PublicActivity::Activity", :foreign_key => "owner_id" 
  has_many :vouchers, :foreign_key => "creator_id", :dependent => :destroy
  has_many :assigned_vouchers, :foreign_key => "assignee_id", :class_name => "Voucher"
  has_many :comments, :dependent => :destroy
  devise :database_authenticatable, :omniauthable,
    :recoverable, :rememberable, :trackable, :omniauth_providers => [:google_oauth2]
  #FIXME_AB: Please ensure proper code formatting. space after comma. Space after comma not before comma.
  validates :first_name , :last_name , :email , presence: true
  validates_uniqueness_of :email, :case_sensitive => false
  #/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})$/
  validates_format_of :email, :with => EMAIL_FORMAT
  #before_destroy :ensure_atleast_one_user_remains
  before_validation :strip_blanks
 

  # def strip_blanks
  #   # self.first_name = self.first_name.squish
  #   # self.last_name = self.last_name.squish
  #   self.name = self.name.squish
  # end
  
  def self.from_omniauth(access_token , signed_in_resource = nil)
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
  
  private
  
  # def ensure_atleast_one_user_remains
  #   #FIXME_AB: where are you checking that this user is an admin?
  #   if User.count == 1 || 
  #     raise "Can't delete last user"
  #   end
  # end

end