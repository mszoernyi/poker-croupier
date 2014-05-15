require_relative 'mustache_base'

class TournamentBase < MustacheBase
  attr_reader :log
  attr_reader :data
  attr_reader :auto_play

  def initialize(log,auto_play)
    @log = log
    @auto_play = auto_play
    @data = JSON.parse('[' + File.readlines("#{BASE_DIR}#{log}.json").join(',') + ']').reverse
    @tournament = VisualSpectator::Tournament.new(@data)
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
      player['log_file'] = strip_path_and_extension(player['log_file'])
    end

    average_points = game_winners.inject(0) { |sum, player| sum + player['points'] } / game_winners.length
    game_winners.each do |player|
      player['relative_points'] = player['points'] - average_points
    end

    game_winners
  end
end