
class VisualSpectator::Game
  attr_reader :json, :log, :time, :players

  def initialize(game, trend_reference)
    @json = game['game_json']
    @log = game['game_log']
    @time = game['time']
    @players = game['ranking'].map do |player_name, player|
      player['name'] = player_name
      VisualSpectator::Player.new(player, self)
    end
    @trend_reference = trend_reference.nil? ? self : trend_reference
  end

  def average_points
    @players.inject(0) { |sum, player| sum + player.points } / @players.length
  end

  def trend_reference
    @trend_reference
  end
end