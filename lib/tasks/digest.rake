namespace :notification do
  desc "This is to send an email to users"
  task(:digest => :environment) do
  	User.where(email:"divya@vinsol.com").first.all.each do |user|
       VoucherNotifier.assigned_vouchers(user)
    end                        
  end
end