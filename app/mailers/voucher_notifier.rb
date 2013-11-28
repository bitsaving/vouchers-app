class VoucherNotifier < ActionMailer::Base
  default from: "notifications@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.voucher_notifier.assigned_vouchers.subject
  #
  def assigned_vouchers
            mail(:from => "Testmail@demo.com",:to => user.email,:subject => "Vouchers Assigned")
  end
