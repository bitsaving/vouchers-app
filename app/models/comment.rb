class Comment < ActiveRecord::Base
<<<<<<< HEAD

  validates :description,:presence=>true
=======
  #FIXME_AB: Always remember to add validations
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
  belongs_to :user
  belongs_to :voucher
end
