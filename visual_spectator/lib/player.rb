
class VisualSpectator::Player
  attr_reader :name, :points, :place, :version, :commit, :log

  def initialize(player_name, player)
    @name = player_name
    @points = player['points']
    @place = player['place']
    @version = player['version']
    @commit = player['commit']
    @log = player['log_file']
  end
end