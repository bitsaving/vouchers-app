class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  has_many :notifications
  has_many :vouchers , :foreign_key => "creator_id" , :dependent => :destroy
  has_many :comments , :dependent => :destroy
  devise :database_authenticatable , :omniauthable ,
    :recoverable , :rememberable , :trackable , :omniauth_providers => [:google_oauth2]

  #FIXME_AB: Please ensure proper code formatting. space after comma
  #Fixed
  validates :first_name , :last_name , :email , presence: true
  #FIXME_AB: Uniqueness is not case sensetive. upper case and lower case emails are treated different. Shouldn't be doing that.
  #Fixed
  validates :email, uniqueness: true , :case_sensitive => false
  before_destroy :ensure_atleast_one_user_remains

  def self.from_omniauth(access_token , signed_in_resource = nil)
    data = access_token.info
    #FIXME_AB: Ensure that users table has index on email column
    #Fixed
    user = User.where(:email => data["email"]).first
    #FIXME_AB: Why do you need to return the user specifically, in the below line
    #Fixed
  end

  private

  def ensure_atleast_one_user_remains
    #FIXME_AB: where are you checking that this user is an admin?
    #Fixed
    if User.count == 1
      #FIXME_AB: remove junk log below
      #fixed
      raise "Can't delete last user"
    end
  end
end