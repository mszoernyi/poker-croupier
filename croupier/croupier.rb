$:.push(File.join(File.dirname(__FILE__), 'lib/api'))
$:.push(File.join(File.dirname(__FILE__)))

require 'logger'
require 'delegate_all'

module Croupier

  autoload :Deck, 'lib/deck'
  autoload :Game, 'lib/game'
  autoload :LogHandler, 'lib/log_handler'
  autoload :MultiTournament, 'lib/multi_tournament'
  autoload :Player, 'lib/player'
  autoload :RandomPlayer, 'lib/random_player'
  autoload :RestPlayer, 'lib/rest_player'
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

