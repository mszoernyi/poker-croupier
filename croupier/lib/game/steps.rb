module Croupier::Game::Steps

  autoload :Base, 'lib/game/steps/base'
  autoload :Betting, 'lib/game/steps/betting'
  autoload :DealCommunityCard, 'lib/game/steps/deal_community_card'
  autoload :DealHoleCards, 'lib/game/steps/deal_hole_cards'
  autoload :DealFlop, 'lib/game/steps/deal_flop'
  autoload :Showdown, 'lib/game/steps/showdown'
  autoload :ShuffleCards, 'lib/game/steps/shuffle_cards'

  DealTurnCard = DealCommunityCard
  DealRiverCard = DealCommunityCard
end