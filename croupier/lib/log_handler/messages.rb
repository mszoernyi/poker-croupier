class Croupier::LogHandler::Messages

  def bet(competitor, bet)
    "#{competitor.name} made a bet of #{bet[:amount]} (#{bet[:type]}) and is left with #{competitor.stack} chips. The pot now contains #{bet[:pot]} chips."
  end

  def showdown(competitor, hand)
    "#{competitor.name} showed #{hand.cards.map{|card| card}.join(',')} making a #{hand.name}"
  end

  def winner(competitor, amount)
    "#{competitor.name} won #{amount}"
  end
end