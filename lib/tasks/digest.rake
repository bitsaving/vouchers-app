namespace :notification do
  desc "This is to send an email to users"
  task(:digest => :environment) do
  	User.all.each do |user|
       VoucherNotifier.delay.assigned_vouchers(user)
    end                        
  end
end