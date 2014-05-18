require_relative 'functions'

class VisualSpectator::Player
  attr_reader :name, :points, :place, :version, :commit, :log

  def initialize(player, game)
    @name = player['name']
    @points = player['points']
    @place = player['place']
    @version = player['version']
    @commit = player['commit']
    @log = strip_path_and_extension(player['log_file'])
    @game = game
  end

  def relative_points
    @points - @game.average_points
  end

  def trend_direction
    trend = relative_points - @game.trend_reference.players.find{ |player| player.name == @name }.relative_points
    return '' if trend.abs < 8
    trend > 0 ? 'up' : 'down'
  end
end