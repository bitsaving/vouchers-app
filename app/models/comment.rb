class Comment < ActiveRecord::Base

  validates :description,:presence=>true
  #FIXME_AB: Plase also add validation for user_id and voucher_id
  #FIXME_AB: On a lower prority we should make this comment model as polymorphic. But not now
  belongs_to :user
  belongs_to :voucher
  
end
