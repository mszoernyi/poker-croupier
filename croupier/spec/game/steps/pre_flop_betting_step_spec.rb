require_relative '../../spec_helper/'


describe Croupier::Game::Steps::Betting::PreFlop do

  let(:spectator) { SpecHelper::FakeSpectator.new }
  let(:game_state) do
    Croupier::Game::State.new(SpecHelper::MakeTournamentState.with(
        players: [fake_player("Albert"), fake_player("Bob")],
        spectators: [spectator]
    ))
  end

  def expect_bet_announced(amount, player, type, pot)
    spectator.should_receive(:bet).with(player, amount: amount, type: type, pot: pot)
  end

  def run()
    Croupier::Game::Steps::Betting::PreFlop.new(game_state).run
  end

  xit "should report the blinds than ask other players for their bets" do
    expect_bet_announced 10, game_state.first_player, :raise, 10
    expect_bet_announced 20, game_state.second_player, :raise, 30

    game_state.first_player.strategy.should_receive(:bet_request).and_return(10)
    expect_bet_announced 10, game_state.first_player, :call, 40

    game_state.second_player.strategy.should_receive(:bet_request).and_return(0)
    expect_bet_announced 0, game_state.second_player, :check, 40

    run
  end
end