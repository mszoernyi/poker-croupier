require_relative '../../../spec_helper'

describe Croupier::Game::Steps::Betting::State do
  let(:game_state) { Croupier::Game::State.new (SpecHelper::MakeTournamentState::with({players: [fake_player, fake_player]})) }
  let(:betting_state) {
    Croupier::Game::Steps::Betting::State.new(game_state)
  }

  describe "#data" do
    it "should return the game state augmented with the betting state variables" do
      betting_state.data.should == {
          players: [
              {
                  name: "FakePlayer",
                  stack: 1000,
                  status: "active",
                  bet: 0,
                  hole_cards: [],
                  id: 0
              },
              {
                  name: "FakePlayer",
                  stack: 1000,
                  status: "active",
                  bet: 0,
                  hole_cards: [],
                  id: 1
              }
          ],
          small_blind: 10,
          orbits: 0,
          dealer: 0,
          community_cards: [],
          current_buy_in: 0,
          pot: 0,
          minimum_raise: 20,
          in_action: 1
      }
    end

  end
end