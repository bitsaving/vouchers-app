namespace :demo do
     desc "This is to send an email to users"
     task(:mail => :environment) do
     VoucherNotifier.assigned_vouchers(User.find(2)).deliver!    # as we saw in Step7 above                        
     end
     end