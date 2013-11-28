# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
VoucherApp::Application.initialize!
VoucherApp::Application.configure do
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
address:"smtp.gmail.com",
port:587,
domain:"gmail.com",
authentication: "plain",
user_name:"divya@vinsol.com",
password:"vinsol12345",
enable_starttls_auto: true
}
end

# require "acts_as_archive/adapters/rails#{Rails.version[0..0]}" if defined?(Rails)
