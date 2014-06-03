require_relative '../spec_helper'
require 'securerandom'

describe Croupier::Game::State do

  describe "#transfer_bet" do
    it "should transfer the amount requested from the player to the pot" do
      api_player = SpecHelper::DummyClass.new
      game_state = Croupier::Game::State.new(SpecHelper::MakeTournamentState.with players: [Croupier::Player.new(api_player)])
      allow(api_player).to receive(:name).and_return("Joe")

      game_state.transfer_bet game_state.players.first, 40, :raise

      expect(game_state.players.first.stack).to eq(960)
      expect(game_state.pot).to eq(40)
    end
  end

  describe "#last_aggressor" do
    let(:game_state) { game_state = Croupier::Game::State.new(SpecHelper::MakeTournamentState.with(players: [fake_player('a'), fake_player('b'), fake_player('c')])) }

    it "should return the first_player if there was no aggression" do
      expect(game_state.last_aggressor).to eq(game_state.first_player)
    end

    it "should return the second player if it raises" do
      game_state.transfer_bet game_state.second_player, 100, :raise

      expect(game_state.last_aggressor).to eq(game_state.second_player)
    end

    it "should return the dealer if it raises" do
      game_state.transfer_bet game_state.dealer, 100, :raise

      expect(game_state.last_aggressor).to eq(game_state.dealer)
    end

    it "should return the first_player if the second_player just calls" do
      game_state.transfer_bet game_state.first_player, 100, :raise
      game_state.transfer_bet game_state.second_player, 100, :call

      expect(game_state.last_aggressor).to eq(game_state.first_player)
    end

    context "after an aggression when #reset_last_aggressor is called" do
      it "should return the first_player again" do
        game_state.transfer_bet game_state.second_player, 100, :raise
        game_state.reset_last_aggressor
        expect(game_state.last_aggressor).to eq(game_state.first_player)
      end
    end
  end

  describe "#data" do
    context "when there is a single player" do

      let(:strategy) {
        SpecHelper::DummyClass.new.tap { |strategy| allow(strategy).to receive(:name).and_return("Joe") }
      }
      let(:game_state) { Croupier::Game::State.new(SpecHelper::MakeTournamentState.with players: [Croupier::Player.new(strategy)]) }

      it "should return the tournament state with game state added" do
        expect(game_state.data).to eq({
            players: [{ id: 0, name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil}],
            small_blind: 10,
            orbits: 0,
            dealer: 0,
            community_cards: [],
            current_buy_in: 0,
            pot: 0,
            uuid: game_state.uuid
        })
      end

      it "should also include the community cards" do
        community_card = PokerRanking::Card::by_name('Queen of Spades')
        game_state.community_cards << community_card
        expect(game_state.data).to eq({
            players: [{ id: 0, name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil}],
            small_blind: 10,
            orbits: 0,
            dealer: 0,
            community_cards: [community_card.data],
            current_buy_in: 0,
            pot: 0,
            uuid: game_state.uuid
        })

      end
    end
  end

end