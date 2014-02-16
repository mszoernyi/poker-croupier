class Croupier::LogHandler::Messages

  def show_cards(competitor, hand)
    "#{competitor.name} showed #{hand.cards.map{|card| card}.join(',')} making a #{hand.name}"
  end

  def winner(competitor, amount)
    "#{competitor.name} won #{amount}"
  end
end