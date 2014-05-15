
class VisualSpectator::Game
  attr_reader :json, :log, :time, :players

  def initialize(game)
    @json = game['game_json']
    @log = game['game_log']
    @time = game['time']
    @players = game['ranking'].map { |player_name, player| VisualSpectator::Player.new(player_name, player) }
  end
end