require "sinatra"
require "mustache"

require "twitter"
require "yaml"

set :bind, '0.0.0.0'
set :public_folder, File.dirname(__FILE__)

get "/" do
  List.new.render
end

get "/game" do
  Game.new(request[:game_log]).render
end

get "/tournament" do
  Tournament.new(request[:tournament_log], request[:auto_play]).render
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

BASE_DIR = File.dirname(__FILE__)+"/../"
LOG_DIR = File.dirname(__FILE__)+"/../log/"
PREVIOUS_EVENTS_DIR = File.dirname(__FILE__)+"/../previous_events/"

def strip_extension(file)
  File.dirname(file).split('/')[-1] + "/" + File.basename(file, ".*")
end

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__)
end

class List < MustacheBase
  def log_files
    Dir.glob("#{LOG_DIR}tournament_*.json").sort.map { |file| {:file => strip_extension(file)} }
  end

  def previous_events
    Dir.glob("#{PREVIOUS_EVENTS_DIR}*/tournament_*.json").sort.map { |file| {:file => strip_extension(file)} }
  end
end

class Tournament < MustacheBase
  attr_reader :log
  attr_reader :auto_play

  def initialize(log,auto_play)
    @log = log
    @auto_play = auto_play
    @data = JSON.parse('[' + File.readlines("#{BASE_DIR}#{log}.json").join(',') + ']').reverse
  end

  def games
    result = []
    data = auto_play ? @data.slice(0..20) : @data

    data.each_with_index do |game, index|
      game_winners = game_winners(game)
      calculate_trends(game_winners, index)

      result << {
          game_path: strip_extension(game['game_json']),
          time: game['time'],
          game_first: game_winners.sort_by { |player| player['place'] }[0]['name'],
          game_second: game_winners.sort_by { |player| player['place'] }[1]['name'],
          game_places: game_winners.sort_by { |player| player['place'] },
          tournament_leader: game_winners.sort_by { |player| player['points'] }[-1]['name'],
          tournament_leader_board: game_winners.sort_by { |player| -player['points'] }
      }
    end
    result
  end

  def calculate_trends(game_winners, index)
    earlier_index = [index + 20, @data.length - 1].min
    earlier_player_states = game_winners(@data[earlier_index])
    game_winners.each do |player|
      earlier_state = earlier_player_states.select { |earlier| earlier['name'] == player['name'] }.first
      player['trend'] = player['relative_points'] - earlier_state['relative_points']
      player['trend_direction'] = player['trend'] > 0 ? 'up' : 'down'
      player['trend_direction'] = '' if player['trend'].abs < 8
    end
  end

  def game_winners(game)
    game_winners = []
    game['ranking'].each_pair do |name, data|
      game_winners << { 'name' => name }.merge(data)
    end
    game_winners.each do |player|
      player['log_file'] = strip_extension(player['log_file'])
    end

    average_points = game_winners.inject(0) { |sum, player| sum + player['points'] } / game_winners.length
    game_winners.each do |player|
      player['relative_points'] = player['points'] - average_points
    end

    game_winners
  end
end

class Game < MustacheBase
  def initialize(log)
    @log_file = log
  end

  def game_json
    File.read("#{BASE_DIR}#{@log_file}.json")
  end

  def tweets
    config_file = File.dirname(__FILE__) + '/twitter_api.yml'
    return "[]" unless FileTest.exist? config_file

    twitter_config = YAML.load(File.open(config_file).read)

    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = twitter_config['key']
        config.consumer_secret = twitter_config['secret']
      end

      JSON.generate(client.search(twitter_config['search'], rpp: 10, result_type: 'recent').take(10).map do |tweet|
        {
            profile_image: tweet.user.profile_image_url.to_s,
            username: tweet.user.username,
            text: tweet.text
        }
      end)
    rescue
      "[]"
    end
  end
end
