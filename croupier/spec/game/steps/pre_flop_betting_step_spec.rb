require_relative '../../spec_helper/'


describe Croupier::Game::Steps::Betting::PreFlop do

  let(:game_state) do
    Croupier::Game::State.new(SpecHelper::MakeTournamentState.with(
        players: [fake_player("Albert"), fake_player("Bob")],
    ))
  end

  def run()
    Croupier::Game::Steps::Betting::PreFlop.new(game_state).run
  end

  it "should report the blinds than ask other players for their bets" do
    expect(game_state.first_player.strategy).to receive(:bet_request).and_return(10)

    expect(game_state.second_player.strategy).to receive(:bet_request).and_return(0)

    run

    expect(game_state.players[0].total_bet).to eq(20)
    expect(game_state.players[1].total_bet).to eq(20)
  end
end