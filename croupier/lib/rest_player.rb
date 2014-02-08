require 'player_strategy'

class Croupier::RestPlayer

  attr_reader :name

  def initialize(name, url)
    @name = name
  end

  def hole_card(card)
  end

  def bet_request(game_state)
    0
  end

  def open
  end

  def close
  end

  def competitor_status(competitor)
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