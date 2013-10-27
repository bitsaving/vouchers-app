#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---
module CurrentUser
  extend ActiveSupport::Concern
  private
  def set_user
    @user = current_user
    #FIXME_AB: I would prefer not to catch this exception instead we should avoid having such situations
  rescue ActiveRecord::RecordNotFound
redirect_to sessions_new_path
  end
end
