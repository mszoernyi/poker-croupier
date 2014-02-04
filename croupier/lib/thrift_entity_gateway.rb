module Croupier::ThriftEntityGateway

  class << self
    def [](source_entity)
      send("get_#{source_entity.class.name.sub(/::/, '__')}".to_sym, source_entity)
    end

    def bet(hash)
      API::Bet.new.tap do |api_bet|
        api_bet.amount = hash[:amount]
        api_bet.type = API::BetType.const_get(hash[:type].capitalize)
        api_bet.new_pot_size = hash[:pot]
      end
    end

    def bet_limits(hash)
      API::BetLimits.new do |api_bet_limits|
        api_bet_limits.to_call = hash[:to_call]
        api_bet_limits.minimum_raise = hash[:minimum_raise]
      end
    end

    private

    def get_Croupier__Player(source)
      API::Competitor.new.tap do |target|
        target.name = source.name
        target.stack = source.stack
      end
    end
    
    def get_PokerRanking__Hand(source)
      API::HandDescriptor.new.tap do |descriptor|
        descriptor.name = source.name
        descriptor.ranks = [source.rank, source.value, source.second_value, *source.kickers]
      end
    end

    def get_PokerRanking__Card(source)
      API::Card.new.tap do |target|
        target.value = source.value
        target.suit = API::Suit.const_get(source.suit.to_sym)
        target.name = source.to_s
      end
    end
  end
end