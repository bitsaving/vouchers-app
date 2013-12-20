class Comment < ActiveRecord::Base
  validates :description, :presence => true
  #FIXME_AB: On a lower priority we should make this comment model as polymorphic. But not now
  belongs_to :user
  belongs_to :voucher
  validates :user_id, :voucher_id, :numericality => { :only_integer => true }, :allow_blank => true
end
