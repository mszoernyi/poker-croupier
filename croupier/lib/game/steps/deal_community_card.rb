
class Croupier::Game::Steps::DealCommunityCard < Croupier::Game::Steps::Base
  def run
    return unless should_deal_card

    card = game_state.deck.next_card!
    game_state.community_cards << card
    game_state.log_state message: "community card #{card}"
  end

  private

  def should_deal_card
    (game_state.players.count { |player| player.active? }) > 1
  end
end