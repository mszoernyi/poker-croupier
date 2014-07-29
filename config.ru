require_relative 'croupier/app'
require 'sidekiq/web'

map '/' do
  run Sinatra::Application
end

map '/sidekiq' do
  run Sidekiq::Web
end