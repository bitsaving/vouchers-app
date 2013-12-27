class DashboardsController < VouchersController
  skip_before_action :set_voucher, only: :show

  def show
    @vouchers =  Voucher.not_accepted.assignee(current_user.id).including_accounts_and_transactions.order('updated_at desc') 
  end

end