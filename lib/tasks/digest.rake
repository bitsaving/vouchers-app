namespace :notification do
  desc "This is to send an email to users"
  task(:digest => :environment) do
  	# User.all.each do |user|
       VoucherNotifier.assigned_vouchers(User.where(email:"divya@vinsol.com").first).deliver
    # end                        
  end
end