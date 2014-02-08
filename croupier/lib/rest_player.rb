require 'player_strategy'

class Croupier::RestPlayer

  def initialize
  end

  def hole_card(card)
  end

  def bet_request(game_state, index, pot, hash)
    0
  end

  def open
  end

  def close
  end

  def competitor_status(competitor)
  end

  def name
    "REST player"
  end

  def bet(competitor, bet)
  end

  def community_card(card)
  end

  def showdown(competitor, hand)
  end

  def winner(competitor, amount)
  end

  def shutdown
  end

end