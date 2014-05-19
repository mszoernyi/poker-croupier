require_relative 'mustache_base'

class TournamentBase < MustacheBase
  attr_reader :log
  attr_reader :data
  attr_reader :tournament
  attr_reader :auto_play

  def initialize(log,auto_play)
    @log = log
    @auto_play = auto_play
    data = JSON.parse('[' + File.readlines("#{BASE_DIR}#{log}.json").join(',') + ']')
    @tournament = VisualSpectator::Tournament.new(data)
  end
end