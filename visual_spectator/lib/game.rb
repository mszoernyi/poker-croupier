class VisualSpectator::Game
  attr_reader :json, :log, :time, :players, :active_players

  def initialize(game, tournament, index)
    @json = game['game_json']
    @log = game['game_log']
    @time = game['time']
    @players = game['ranking'].map do |player_name, player|
      player['name'] = player_name
      VisualSpectator::Player.new(player, self)
    end
    @active_players = game['ranking'].select { | _, player | player['active'] }.map do |player_name, player|
      player['name'] = player_name
      VisualSpectator::Player.new(player, self)
    end
    @tournament = tournament
    @index = index
  end

  def average_points
    @players.inject(0) { |sum, player| sum + player.points } / @players.length
  end

  def trend_reference
    @tournament.games[[0, @index - 20].max]
  end

  def previous
    @tournament.games[[0, @index - 1].max]
  end

  def player(name)
    @players.find{ |player| player.name == name }
  end
end
