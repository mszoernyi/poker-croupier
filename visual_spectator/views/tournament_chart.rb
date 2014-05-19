require_relative 'tournament_base'
require_relative '../lib/functions'

class TournamentChart < TournamentBase
  def chart_data
    header = ['Time'] + player_names + player_names

    result = []
    result << header
    tournament.games.each_with_index do |game, index|
      round = [game.time]
      player_names.each do |name|
        round << game.player(name).relative_points
      end

      previous_game = tournament.games[[index - 1, 0].max] #load_players([data.length - 1, index + 1].min)
      player_names.each do |name|
        this_player = game.player(name)
        previous_player = previous_game.player(name)

        if this_player.commit != previous_player.commit || index == 0
          round << this_player.relative_points
        else
          round << nil
        end

      end
      result << round
    end

    JSON.generate result
  end

  def player_names
    tournament.players.map { |player| player.name }
  end

  def log_files
    JSON.generate(data.map { |game| strip_path_and_extension game['game_log'] }.reverse)
  end

  def deploy_columns
    tournament.players.each_index.map do |index|
      { 'col' => @tournament.players.length + index }
    end
  end
end
