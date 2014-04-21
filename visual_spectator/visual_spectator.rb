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

class TournamentBase < MustacheBase
  attr_reader :log
  attr_reader :data
  attr_reader :auto_play

  def initialize(log,auto_play)
    @log = log
    @auto_play = auto_play
    @data = JSON.parse('[' + File.readlines("#{BASE_DIR}#{log}.json").join(',') + ']').reverse
  end

  def load_players(index)
    players = game_winners(@data[index])
    calculate_trends(players, index)
    players
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

class TournamentChart < TournamentBase
  def chart_data
    player_names = load_players(0).map { |player| player['name'] }
    header = ['Time'] + player_names + player_names

    result = []
    data.each_with_index do |game, index|
      players = load_players(index)
      round = [game['time']]
      player_names.each do |name|
        round << players.select { |player| player['name'] == name }.first['relative_points']
      end

      previous_players = load_players([data.length - 1, index + 1].min)
      player_names.each do |name|
        this_player = players.select { |player| player['name'] == name }.first
        previous_player = previous_players.select { |player| player['name'] == name }.first

        if this_player['commit'] != previous_player['commit'] || index + 1 == data.length
          round << this_player['relative_points']
        else
          round << nil
        end

      end
      result << round
    end
    result << header

    JSON.generate result.reverse
  end

  def deploy_columns
    result = []
    nof_players = load_players(0).length
    nof_players.times do |index|
      result << { 'col' => nof_players + index }
    end
    result
  end
end

class Tournament < TournamentBase
  def games
    result = []
    displayed_data = auto_play ? data.slice(0..20) : data

    displayed_data.each_with_index do |game, index|
      players = load_players(index)

      result << {
          game_path: strip_extension(game['game_json']),
          time: game['time'],
          game_first: players.sort_by { |player| player['place'] }[0]['name'],
          game_second: players.sort_by { |player| player['place'] }[1]['name'],
          game_places: players.sort_by { |player| player['place'] },
          tournament_leader: players.sort_by { |player| player['points'] }[-1]['name'],
          tournament_leader_board: players.sort_by { |player| -player['points'] }
      }
    end
    result
  end
end

class Game < MustacheBase
  attr_reader :game_json

  def initialize(log)
    @game_json = File.read("#{BASE_DIR}#{log}.json")
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

  def chart_data
    data = JSON.parse(@game_json)#.
    header = ['Round'] + data[0]['game_state']['players'].map { |player| player['name'] }
    rounds = data.
        each_with_index.
        select { |record, index| not record.key? 'type' }.
        map { |round, index| [index] + round['game_state']['players'].map { |player| player['stack'] } }
    JSON.generate([header] + rounds)
  end
end
