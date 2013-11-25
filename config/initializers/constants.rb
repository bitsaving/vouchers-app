#FIXME_AB: Name thse custom formats a better name. I can help if you need
Date::DATE_FORMATS[:normal_format] = "%d/%m/%Y"
Date::DATE_FORMATS[:string_format] = "%d %b %Y"
# Date::DATE_FORMATS[:string_month] = '%B'
# Date::DATE_FORMATS[:minute_format] = "%e-%b-%y , %I:%M"
Time::DATE_FORMATS[:short_ordinal]  = ->(time) { time.strftime("%e-%b-%y , %I:%M %p") }
 ACCOUNT_FILTER_OPTIONS = ["debit" ,"credit"]