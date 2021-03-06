# frozen_string_literal: true
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

port ENV['PORT'] || 3000
environment ENV['RAILS_ENV'] || 'development'

pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

if ENV['RAILS_ENV'] == 'production'
  bind "unix://tmp/sockets/puma.sock"
else
  bind "tcp://localhost:#{ENV['PORT'] || 3000}"
end
