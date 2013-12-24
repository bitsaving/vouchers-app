module AccountsHelper
  def getaccount(id)
    @account = Account.find_by(id: id)
  end
end
