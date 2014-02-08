class Croupier::Game::Steps::Betting::State
  attr_reader :game_state
  attr_accessor :minimum_raise

  def initialize(game_state)
    @game_state = game_state
    @minimum_raise = @game_state.big_blind
  end

  def players
    @game_state.players
  end

  def transfer_bet(player, bet, bet_type)
    @game_state.transfer_bet player, bet, bet_type
  end

  def ==(other)
    @minimum_raise = other.minimum_raise and @game_state = other.game_state
  end

  def data
    game_state.data
  end
end