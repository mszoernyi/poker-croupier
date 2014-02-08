
class PlayerStrategy::Handler
  def name
    ARGV[1] || "Rudy Ruby"
  end

  def competitor_status(competitor)
  end

  def hole_card(card)
  end

  def community_card(card)
  end

  def bet(competitor, bet)
  end

  def bet_request(pot, limits)
    case rand(0..4)
      when 0
        0
      when 1
        limits.to_call + limits.minimum_raise * rand(1..4)
      else
        limits.to_call
    end
  end

  def showdown(comptetior, cards, hand)
  end

  def winner(competitor, amount)
  end

  def shutdown
    abort('Shutting down server')
  end
end