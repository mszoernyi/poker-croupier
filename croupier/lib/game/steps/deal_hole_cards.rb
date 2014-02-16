class Croupier::Game::Steps::DealHoleCards < Croupier::Game::Steps::Base
  def run
    game_state.log_state
    deal_one_card_to_each_player
    deal_one_card_to_each_player
  end

  private

  def deal_one_card_to_each_player
    game_state.each_player_from game_state.first_player do |player|
      if player.has_stack?
        player.hole_card(game_state.deck.next_card!)
        game_state.log_state
      end
    end
  end
end