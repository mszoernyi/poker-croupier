require 'card'

class Croupier::Deck
  def initialize
    shuffle
  end

  def next_card!
    id = @permutation.pop

    return PokerRanking::Card::by_id(id) unless id.nil?
  end

  def shuffle
    @permutation = (0.upto 51).to_a.shuffle
  end
end