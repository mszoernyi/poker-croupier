require "sinatra"
require "twitter"
require "yaml"

require_relative "views/game"
require_relative "views/list"
require_relative "views/tournament"
require_relative "views/tournament_chart"

set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__)

BASE_DIR = File.dirname(__FILE__)+"/../"
LOG_DIR = File.dirname(__FILE__)+"/../log/"
PREVIOUS_EVENTS_DIR = File.dirname(__FILE__)+"/../previous_events/"

get "/" do
  List.new.render
end

get "/game" do
  Game.new(request[:game_log]).render
end

get "/tournament" do
  Tournament.new(request[:tournament_log], request[:auto_play]).render
end

get "/tournament_chart" do
  TournamentChart.new(request[:tournament_log], request[:auto_play]).render
end

get "/log" do
  content_type :text
  File.read("#{BASE_DIR}#{request[:log]}.log")
end

get "/json" do
  content_type :text
  if request[:log].include? "tournament_"
    '[' + File.readlines("#{BASE_DIR}#{request[:log]}.json").join(',') + ']'
  else
    File.read("#{BASE_DIR}#{request[:log]}.json")
  end
end
