module UsersHelper
  def get_user(id)
    User.find_by(id: id)
  end

end
