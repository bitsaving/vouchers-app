#FIXME_AB: Name thse custom formats a better name. I can help if you need
Date::DATE_FORMATS[:normal_format] = "%d/%m/%Y"
Date::DATE_FORMATS[:string_format] = "%d %b %Y"
Time::DATE_FORMATS[:short_ordinal]  = ->(time) { time.strftime("%e-%b-%y , %I:%M %p") }
ACCOUNT_FILTER_OPTIONS = ["Both" ,"debit" ,"credit"]
EMAIL_FORMAT =  /\A([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})\Z/i
VOUCHER_STATES = ['drafted', 'pending', 'approved', 'accepted', 'rejected', 'archived']
PAYMENT_TYPES = [ "Cash" , "Cheque", "Credit card", "Bank transfers" ]