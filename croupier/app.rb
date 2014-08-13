require 'sinatra'
require 'json'

require 'sidekiq/web'

require_relative 'croupier'
require_relative 'workers/run_game_worker'

set :bind, '0.0.0.0'

post '/game' do
  RunGameWorker.perform_async params[:teams],  params[:response_url]
  JSON.generate success: true
end

get '/check' do
  JSON.generate success: true
end