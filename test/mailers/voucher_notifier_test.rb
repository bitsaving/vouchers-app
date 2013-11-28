require 'test_helper'

class VoucherNotifierTest < ActionMailer::TestCase
  test "assigned_vouchers" do
    mail = VoucherNotifier.assigned_vouchers
    assert_equal "Assigned vouchers", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
