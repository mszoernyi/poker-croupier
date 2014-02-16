class Croupier::Game::Runner
  include Croupier::Game::Steps
  GAME_STEPS = [
      ShuffleCards,
      DealHoleCards,
      Betting::PreFlop,
      DealFlop,
      Betting::Step,
      DealTurnCard,
      Betting::Step,
      DealRiverCard,
      Betting::Step,
      Showdown
  ]

  def run(tournament_state)
    game_state = Croupier::Game::State.new(tournament_state)
    GAME_STEPS.each do |step_type|
      step_type.new(game_state).run
    end
  end
end