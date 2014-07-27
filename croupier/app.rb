require 'sinatra'
require 'json'
require_relative 'croupier'

post '/game/start' do
  response_url = params[:response_url]

  players = params[:players]

  controller = Croupier::SitAndGo::Controller.new
  controller.logger = Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")

  players.each do |player|
    controller.register_rest_player player['name'], player['url']
  end

  ranking = controller.start_sit_and_go
end

get '/check' do
  JSON.generate success: true
end