class User < ActiveRecord::Base
  acts_as_paranoid
  include PublicActivity::Common
  has_many :notifications
  has_many :vouchers,:foreign_key=>"creator_id",:dependent=>:destroy
  has_many :comments ,:dependent=>:destroy
  devise :database_authenticatable, :omniauthable,
    :recoverable, :rememberable, :trackable,  :omniauth_providers => [:google_oauth2]

  #FIXME_AB: Please ensure proper code formatting. space after comma
  validates :first_name,:last_name,:email ,presence: true
  #FIXME_AB: Uniqueness is not case sensetive. upper case and lower case emails are treated different. Shouldn't be doing that.
  validates :email, uniqueness: true
  before_destroy :ensure_an_admin_remains

  def self.from_omniauth(access_token, signed_in_resource=nil)
    data = access_token.info
    #FIXME_AB: Ensure that users table has index on email column
    user = User.where(:email => data["email"]).first
    #FIXME_AB: Why do you need to return the user specifically, in the below line
    user
  end

  private
  def ensure_an_admin_remains
    #FIXME_AB: where are you checking that this user is an admin?
    if User.count == 1
      #FIXME_AB: remove junk log below
      Rails.logger.debug "DFDFDF"
      raise "Can't delete last user"
    end
  end
end