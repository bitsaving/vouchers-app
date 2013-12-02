module AccountsHelper
  def getAccount(id)
  	Account.find(id).name if !id.blank?
  end
end
