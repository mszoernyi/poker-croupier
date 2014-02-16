
require 'card'

require 'poker_ranking'

class Croupier::Game::Steps::Showdown < Croupier::Game::Steps::Base
  def run
    while
      find_winner
      break if @winners == []
      award
    end
  end

  private

  def find_winner
    @winners = []
    @best_hand = PokerRanking::Hand.new([])

    if game_state.players.count { |player| player.active? and player.total_bet > 0 } == 1
      @winners = game_state.players.select { |player| player.active? and player.total_bet > 0 }
      @best_hand = PokerRanking::Hand.new [*@winners[0].hole_cards, *game_state.community_cards]
    else
      game_state.each_player_from game_state.last_aggressor do |player|
        examine_cards_of player
      end
    end
  end

  def examine_cards_of(player)
    return unless player.active?
    return if player.total_bet <= 0

    hand = PokerRanking::Hand.new [*player.hole_cards, *game_state.community_cards]
    return if @best_hand.defeats? hand

    game_state.each_observer do |observer|
      observer.show_cards player, hand
    end

    @winners = [] if hand.defeats? @best_hand

    @winners << player
    @best_hand = hand
  end

  def award
    side_pot = winners_side_pot
    remainder = side_pot % @winners.length
    @winners.each_with_index do |winner, index|
      amount = (side_pot / @winners.length).floor - (index < remainder ? 1 : 0)
      game_state.transfer winner, -amount
      announce winner, amount
    end
  end

  def announce(winner, amount)
    game_state.each_observer do |observer|
      observer.winner winner, amount
    end
  end

  def winners_side_pot
    pot = 0
    side_pot_cap = calculate_side_pot_size
    game_state.players.each do |player|
      bet_in_side_pot = [player.total_bet, side_pot_cap].min
      player.total_bet -= bet_in_side_pot
      pot += bet_in_side_pot
    end
    pot
  end



  def calculate_side_pot_size
    @winners.map { |player| player.total_bet }.min
  end
end
