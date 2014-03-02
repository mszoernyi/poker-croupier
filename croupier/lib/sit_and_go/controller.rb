
class Croupier::SitAndGo::Controller
  def initialize
    @croupier = Croupier::SitAndGo::Runner.new
    @croupier.set_logger Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")
  end

  def register_in_process_player(name, strategy)
    player = Croupier::Player.new(strategy.new name)
    @croupier.register_player player
    Croupier.logger.info "Connected #{player.name} with #{strategy} strategy"
  end

  def register_rest_player(name, url)
    player = Croupier::Player.new(Croupier::RestPlayer.new name, url)
    @croupier.register_player player
    Croupier.logger.info "Connected #{player.name} at #{url}"
  end

  def start_sit_and_go
    @croupier.start_sit_and_go.get.reverse
  end

  def players_running?
    @croupier.players_running?
  end

end