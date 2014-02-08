$:.push(File.join(File.dirname(__FILE__), 'lib/api'))
$:.push(File.join(File.dirname(__FILE__)))

require 'thrift'
require_relative '../common/lib/delegate_all'

module Croupier

  autoload :Deck, 'lib/deck'
  autoload :Game, 'lib/game'
  autoload :Handler, 'lib/handler'
  autoload :LogHandler, 'lib/log_handler'
  autoload :Player, 'lib/player'
  autoload :ThriftPlayer, 'lib/thrift_player'
  autoload :ThriftPlayerBuilder, 'lib/thrift_player_builder'
  autoload :ThriftEntityGateway, 'lib/thrift_entity_gateway'
  autoload :ThriftObserver, 'lib/thrift_observer'
  autoload :Tournament, 'lib/tournament'

  class << self
    attr_accessor :log_file

    def logger
      @logger ||= Croupier::LogHandler::MultiLogger.new(
          Logger.new("#{log_file}.log"),
          Logger.new(STDOUT)
      )
    end
  end
end

