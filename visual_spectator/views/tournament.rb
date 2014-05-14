require_relative 'tournament_base'

class Tournament < TournamentBase
  def games
    result = []
    displayed_data = auto_play ? data.slice(0..20) : data

    displayed_data.each_with_index do |game, index|
      players = load_players(index)

      result << {
          game_path: strip_path_and_extension(game['game_json']),
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
