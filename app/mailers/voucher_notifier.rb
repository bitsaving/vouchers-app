class VoucherNotifier < ActionMailer::Base
  def assigned_vouchers(user)
    @user = user
    if @user.assigned_vouchers.present?
      mail(:from => "voucherapp@vinsol.com", :to => @user.email, :subject => @user.assigned_vouchers.count.to_s + " vouchers assigned")
    end
  end
end