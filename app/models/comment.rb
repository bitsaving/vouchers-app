class Comment < ActiveRecord::Base
  validates :description, :presence => true
  #FIXME_AB: On a lower priority we should make this comment model as polymorphic. But not now
  belongs_to :user
  belongs_to :voucher

  #FIXME_AB: What if user_id or voucher_id is blank. We should have validations for them too. I guess we have discussed it once in evaluation.
  validates :user_id, :voucher_id, :numericality => { :only_integer => true }
  validates :user_id, :voucher_id, presence: true
end
