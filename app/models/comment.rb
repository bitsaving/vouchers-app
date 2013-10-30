class Comment < ActiveRecord::Base
<<<<<<< HEAD
validates :description,:presence=>true

=======
<<<<<<< HEAD

  validates :description,:presence=>true
=======
  #FIXME_AB: Always remember to add validations
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
  belongs_to :user
  belongs_to :voucher
end
