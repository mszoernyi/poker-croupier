
class Croupier::Handler
  def initialize
    @croupier = Croupier::Tournament::Runner.new
    @croupier.register_spectator Croupier::LogHandler::HumanReadable.new
    @croupier.register_spectator Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")
  end

  def register_thrift_player(address)
      begin
        player = Croupier::ThriftPlayerBuilder.new.build_player(address)
        player.open
        @croupier.register_player player
        Croupier.logger.info "Connected #{player.name} at #{address}"
      rescue Exception => e
        Croupier.logger.error $!.message
        raise e
      end
  end

  def start_sit_and_go
    @croupier.start_sit_and_go.get.reverse.each_with_index do |player, index|
      Croupier.logger.info "Place #{index+1}: #{player.name}"
    end
  end

  def shutdown
    Croupier.logger.close
    abort('Shutting down server')
  end

end