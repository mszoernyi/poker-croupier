require_relative 'tournament_base'
require_relative '../lib/functions'

class Tournament < TournamentBase
  def games
    result = []
    displayed_data = auto_play ? tournament.games.reverse.slice(0..20) : tournament.games.reverse

    displayed_data.each do |game|
      winners = game.players.sort_by { |player| player.place }
      leaders = game.players.sort_by { |player| -player.points }

      result << {
          game_path: strip_path_and_extension(game.json),
          time: game.time,
          game_first: winners.first.name,
          game_second: winners[1].name,
          game_places: winners,
          tournament_leader: leaders.first.name,
          tournament_leader_board: leaders.reverse
      }
    end
    result
  end
end
