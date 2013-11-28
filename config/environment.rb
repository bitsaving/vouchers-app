# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
VoucherApp::Application.initialize!
VoucherApp::Application.configure do
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
address: "smtp.mandrillapp.com",
port: 587,
domain: 'vouchers.domain4now.com',
user_name: 'voucherapp@vinsol.com',
password: '7UI4KLloVC54fB_JArurow',
authentication: 'plain',
enable_starttls_auto: true
}
end

# require "acts_as_archive/adapters/rails#{Rails.version[0..0]}" if defined?(Rails)
