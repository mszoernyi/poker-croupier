require_relative 'tournament_base'

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

  def log_files
    JSON.generate(data.map { |game| strip_path_and_extension game['game_log'] }.reverse)
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
