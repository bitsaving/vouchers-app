class Comment < ActiveRecord::Base
  #FIXME_AB: Always remember to add validations
  belongs_to :user
  belongs_to :voucher
end
