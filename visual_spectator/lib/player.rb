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
    return '' if trend.abs < 8
    trend > 0 ? 'up' : 'down'
  end

  def trend
    relative_points - trend_reference_player.relative_points
  end

  private

  def trend_reference_player
    @game.trend_reference.player(@name)
  end
end