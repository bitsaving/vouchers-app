module ReportsHelper
  def get_account_name(id)
    Account.find(id).name if !id.blank?
  end
end