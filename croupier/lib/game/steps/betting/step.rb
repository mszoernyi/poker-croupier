class Croupier::Game::Steps::Betting::Step < Croupier::Game::Steps::Base
  def run
    return unless should_do_betting

    game_state.reset_last_aggressor

    @betting_state = build_betting_state

    @betting_players = 0.upto(game_state.players.length - 1).map do |player|
      Croupier::Game::Steps::Betting::Player.new @betting_state, player
    end

    until betting_is_over?
      @betting_players[@betting_state.in_action].take_turn
      @betting_state.next_player
    end
  end

  private

  def minimum_number_of_bets
    @betting_players.length
  end


  def should_do_betting
    (game_state.players.count { |player| player.active? and not player.allin? }) > 1
  end

  def build_betting_state
    Croupier::Game::Steps::Betting::State.new game_state
  end

  def betting_is_over?
    @betting_players.each do |player|
      if player.active? && (!player.allin?) && player.total_bet != @betting_state.game_state.current_buy_in
        return false
      end
    end
    @betting_state.number_of_bets_so_far >= minimum_number_of_bets
  end


end
