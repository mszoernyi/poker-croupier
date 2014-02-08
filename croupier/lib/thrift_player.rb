require 'player_strategy'

class Croupier::ThriftPlayer
  attr_reader :gateway
  attr_reader :strategy

  def initialize(strategy, transport)
    @strategy = strategy
    @transport = transport
    @gateway = Croupier::ThriftEntityGateway
  end

  def hole_card(card)
    strategy.hole_card(gateway[card])
  end

  def bet_request(game_state)
    strategy.bet_request game_state[:pot], gateway.bet_limits(bet_limits(game_state))
  end


  def open
    @transport.open
  end

  def close
    @transport.close
  end

  def competitor_status(competitor)
    @strategy.competitor_status @gateway[competitor]
  end

  def name
    @name ||= @strategy.name
  end

  def bet(competitor, bet)
    @strategy.bet(@gateway[competitor], @gateway.bet(bet))
  end

  def community_card(card)
    @strategy.community_card @gateway[card]
  end

  def showdown(competitor, hand)
    @strategy.showdown @gateway[competitor], competitor.hole_cards.map { |card| @gateway[card] }, @gateway[hand]
  end

  def winner(competitor, amount)
    @strategy.winner @gateway[competitor], amount
  end

  def shutdown
    @strategy.shutdown
  end

  private

  def to_call(game_state)
    game_state[:pot] - game_state[:players][game_state[:in_action]][:bet]
  end

  def bet_limits(game_state)
    {
        to_call: to_call(game_state),
        minimum_raise: game_state[:minimum_raise]
    }
  end
end