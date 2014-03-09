require_relative '../spec_helper'

describe Croupier::Game::State do

  describe "#transfer_bet" do
    it "should transfer the amount requested from the player to the pot" do
      api_player = SpecHelper::DummyClass.new
      game_state = Croupier::Game::State.new(SpecHelper::MakeTournamentState.with players: [Croupier::Player.new(api_player)])
      api_player.stub(:name).and_return("Joe")

      game_state.transfer_bet game_state.players.first, 40, :raise

      game_state.players.first.stack.should == 960
      game_state.pot.should == 40
    end
  end

  describe "#last_aggressor" do
    let(:game_state) { game_state = Croupier::Game::State.new(SpecHelper::MakeTournamentState.with(players: [fake_player('a'), fake_player('b'), fake_player('c')])) }

    it "should return the first_player if there was no aggression" do
      game_state.last_aggressor.should == game_state.first_player
    end

    it "should return the second player if it raises" do
      game_state.transfer_bet game_state.second_player, 100, :raise

      game_state.last_aggressor.should == game_state.second_player
    end

    it "should return the dealer if it raises" do
      game_state.transfer_bet game_state.dealer, 100, :raise

      game_state.last_aggressor.should == game_state.dealer
    end

    it "should return the first_player if the second_player just calls" do
      game_state.transfer_bet game_state.first_player, 100, :raise
      game_state.transfer_bet game_state.second_player, 100, :call

      game_state.last_aggressor.should == game_state.first_player
    end

    context "after an aggression when #reset_last_aggressor is called" do
      it "should return the first_player again" do
        game_state.transfer_bet game_state.second_player, 100, :raise
        game_state.reset_last_aggressor
        game_state.last_aggressor.should == game_state.first_player
      end
    end
  end

  describe "#data" do
    context "when there is a single player" do

      let(:strategy) {
        SpecHelper::DummyClass.new.tap { |strategy| strategy.stub(:name).and_return("Joe") }
      }
      let(:game_state) { Croupier::Game::State.new(SpecHelper::MakeTournamentState.with players: [Croupier::Player.new(strategy)]) }

      it "should return the tournament state with game state added" do
        game_state.data.should == {
            players: [{ id: 0, name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil}],
            small_blind: 10,
            orbits: 0,
            dealer: 0,
            community_cards: [],
            current_buy_in: 0,
            pot: 0
        }
      end

      it "should also include the community cards" do
        community_card = PokerRanking::Card::by_name('Queen of Spades')
        game_state.community_cards << community_card
        game_state.data.should == {
            players: [{ id: 0, name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil}],
            small_blind: 10,
            orbits: 0,
            dealer: 0,
            community_cards: [community_card.data],
            current_buy_in: 0,
            pot: 0
        }

      end
    end
  end

end