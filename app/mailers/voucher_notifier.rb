class VoucherNotifier < ActionMailer::Base
  default from: MAILER["from"]

  def assigned_vouchers(user)
    @user = user
    if @user.assigned_vouchers.present?
      mail_with_subject(@user.assigned_vouchers.count.to_s + " vouchers assigned", @user)
      # mail(:from => "voucherapp@vinsol.com", :to => @user.email, :subject => @user.assigned_vouchers.count.to_s + " vouchers assigned")
    end
  end

  def notify_assignee(user, voucher)
    @user = user
    @voucher = voucher
    mail_with_subject("Vouchers pending for approval", @user)
  end

  def notify_creator(user, voucher)
    @user = user
    @voucher = voucher
    mail_with_subject("Rejected voucher", @user)
  end

  def mail_with_subject(subject, user)
    mail to: user.email, subject: subject
  end

end