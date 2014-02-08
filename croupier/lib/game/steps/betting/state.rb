class Croupier::Game::Steps::Betting::State
  attr_reader :game_state
  attr_accessor :minimum_raise
  attr_reader :in_action
  attr_reader :number_of_bets_so_far

  def initialize(game_state)
    @game_state = game_state
    @minimum_raise = @game_state.big_blind

    @in_action = game_state.players.index(game_state.first_player)
    @number_of_bets_so_far = 0
  end

  def players
    @game_state.players
  end

  def transfer_bet(player, bet, bet_type)
    @game_state.transfer_bet player, bet, bet_type
  end

  def data
    game_state.data.merge({
      in_action: @in_action,
      minimum_raise: @minimum_raise
    })
  end
  
  def next_player
    @in_action = (@in_action + 1) % (@game_state.players.length)
    @number_of_bets_so_far += 1
  end
end