# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
job_type :custom_rake, "cd :path && RAILS_ENV=:environment #{ @environment == 'development' ? 'bundle' : '/usr/local/bin/bundle' } exec #{ @environment == 'development' ? 'rake' : '/usr/local/bin/rake' } :task --silent :output"
set :output, {:error => 'log/cron_error.log', :standard => 'log/cron_standard.log'}

every :day, :at => '02:30am' do
  custom_rake "notification:digest"

end
every 1.day, at: '02:00' do
  # custom_rake 'db:backup'
  
end
every 1.hours do
  custom_rake "ts:rebuild"
end

every :reboot do
  custom_rake "ts:start"
end