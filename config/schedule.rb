# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, "#{path}/log/cron.log"

every 1.days, at: '12:01am' do
  rake 'create_free_tasks'
end

# Learn more: http://github.com/javan/whenever
