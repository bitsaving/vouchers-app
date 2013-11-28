namespace :demo do
     desc "This is to send an email to users"
     task(:mail => :environment) do
     	User.all.each do |user|
     VoucherNotifier.assigned_vouchers(user).deliver!
     end    # as we saw in Step7 above                        
     end
     end