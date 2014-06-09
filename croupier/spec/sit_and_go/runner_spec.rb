require_relative '../spec_helper'

describe Croupier::SitAndGo::Runner do
  before :each do
    @tournament_state = Croupier::SitAndGo::State.new
    @tournament_state.logger = SpecHelper::DummyClass.new
    allow(Croupier::SitAndGo::State).to receive(:new).and_return(@tournament_state)

    @runner = Croupier::SitAndGo::Runner.new
  end

  describe "#register_player" do
    it "should add the player to the game state" do
      player = double("Player")
      @runner.register_player(player)

      expect(@tournament_state.players).to eq([player])
    end
  end

  describe "#start_sit_and_go" do
    it "should run until there are more than two players in game" do
      allow(Croupier::SitAndGo::Ranking).to receive(:new).and_return(SpecHelper::DummyClass.new)

      allow(@tournament_state).to receive(:number_of_active_players_in_tournament).and_return(2, 1)
      game_state = Croupier::Game::State.new(@tournament_state)
      allow(Croupier::Game::State).to receive(:new).and_return(game_state)
      Croupier::Game::Runner::GAME_STEPS.each do |step|
        instance = double("Game step")
        expect(step).to receive(:new).with(game_state).and_return(instance)
        expect(instance).to receive(:run)
      end

      expect(@tournament_state).to receive(:next_round!)

      @runner.start_sit_and_go
    end

    it "should eliminate players after each round and return ranking" do

      allow(Croupier::Game::Runner).to receive(:new).and_return(SpecHelper::DummyClass.new)

      allow(@tournament_state).to receive(:number_of_active_players_in_tournament).and_return(2, 2, 1)
      allow(@tournament_state).to receive(:next_round!)

      ranking = double("Ranking mock")
      allow(Croupier::SitAndGo::Ranking).to receive(:new).and_return(ranking)
      expect(ranking).to receive(:eliminate).twice
      expect(ranking).to receive(:add_winner).once

      expect(@runner.start_sit_and_go).to eq(ranking)
    end

  end
end