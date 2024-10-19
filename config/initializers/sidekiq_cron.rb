require 'sidekiq'

require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(name: 'Calculate Interest - every 5 minutes', cron: '*/5 * * * *', class: 'CalculateInterestJob')