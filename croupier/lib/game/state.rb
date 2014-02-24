class Croupier::Game::State
  delegate_all :tournament_state

  attr_accessor :community_cards

  def initialize(tournament_state)
    @community_cards = []
    @tournament_state = tournament_state

    reset_last_aggressor
  end

  def current_buy_in
    players.map{ |player| player.total_bet}.max
  end

  def pot
    players.inject(0) { |sum, player| sum + player.total_bet }
  end

  def transfer_bet(player, amount, bet_type)
    original_buy_in = current_buy_in
    player.total_bet += amount
    @last_aggressor = player if current_buy_in > original_buy_in

    player.stack -= amount
    log_state on_turn: players.index(player), message: "#{player.name} made a bet of #{amount} (#{bet_type}) and is left with #{player.stack} chips. The pot now contains #{pot} chips."
  end

  def last_aggressor
    return first_player if @last_aggressor.nil?

    @last_aggressor
  end

  def reset_last_aggressor
    @last_aggressor = nil
  end

  def transfer_amount_won(player, amount)
    player.stack += amount
    player.amount_won += amount
  end

  def data
    @tournament_state.data.merge({
      community_cards: @community_cards.map { |card| card.data },
      current_buy_in: current_buy_in,
      pot: pot
    })
  end

  def log_state(additional_data = {})
    logger.log_state(additional_data.merge game_state: data)
  end
end