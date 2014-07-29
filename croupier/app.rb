require 'sinatra'
require 'json'

require 'sidekiq/web'

require_relative 'croupier'
require_relative 'workers/run_game_worker'

post '/game' do
  RunGameWorker.perform_async params[:players],  params[:response_url]
  JSON.generate success: true
end

get '/check' do
  JSON.generate success: true
end