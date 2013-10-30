namespace :admin do
  desc "To create an admin"
  task :create => :environment do 
    print "Enter first name: "
    first_name = $stdin.gets.chomp
    print "Enter last name: "
    last_name = $stdin.gets.chomp
    print "Enter email: "
    email= $stdin.gets.chomp
    admin =User.new(:first_name=> first_name, :last_name=>last_name,:email=>email,:user_type=>"admin")
    admin.save!
    puts "Admin created"
  end
end