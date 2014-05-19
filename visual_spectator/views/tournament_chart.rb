require_relative 'tournament_base'
require_relative '../lib/functions'

class TournamentChart < TournamentBase
  def chart_data
    JSON.generate [header] + chart_data_for_games
  end

  def log_files
    JSON.generate(data.map { |game| strip_path_and_extension game['game_log'] }.reverse)
  end

  def deploy_columns
    tournament.players.each_index.map do |index|
      { 'col' => @tournament.players.length + index }
    end
  end

  private

  def chart_data_for_games
    tournament.games.map { |game| chart_data_for(game) }
  end

  def chart_data_for(game)
    [game.time] + performance_curves_for(game) + deploy_markers(game)
  end

  def deploy_markers(game)
    player_names.map do |name|
      this_player = game.player(name)
      previous_player = game.previous.player(name)

      if this_player.commit != previous_player.commit
        this_player.relative_points
      else
        nil
      end
    end
  end

  def performance_curves_for(game)
    player_names.map do |name|
      game.player(name).relative_points
    end
  end

  def header
    ['Time'] + player_names + player_names
  end

  def previous_game(index)
    tournament.games[[index - 1, 0].max]
  end

  def player_names
    tournament.players.map { |player| player.name }
  end
end
