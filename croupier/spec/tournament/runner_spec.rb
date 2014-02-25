require_relative '../spec_helper'

describe Croupier::SitAndGo::Runner do
  before :each do
    @tournament_state = Croupier::SitAndGo::State.new
    @tournament_state.set_logger SpecHelper::DummyClass.new
    Croupier::SitAndGo::State.stub(:new).and_return(@tournament_state)

    @runner = Croupier::SitAndGo::Runner.new
  end

  describe "#register_player" do
    it "should add the player to the game state" do
      player = double("Player")
      @runner.register_player(player)

      @tournament_state.players.should == [player]
    end
  end

  describe "#start_sit_and_go" do
    it "should run until there are more than two players in game" do
      Croupier::SitAndGo::Ranking.stub(:new).and_return(SpecHelper::DummyClass.new)

      @tournament_state.stub(:number_of_active_players_in_tournament).and_return(2, 1)
      game_state = Croupier::Game::State.new(@tournament_state)
      Croupier::Game::State.stub(:new).and_return(game_state)
      Croupier::Game::Runner::GAME_STEPS.each do |step|
        instance = double("Game step")
        step.should_receive(:new).with(game_state).and_return(instance)
        instance.should_receive(:run)
      end

      @tournament_state.should_receive(:next_round!)

      @runner.start_sit_and_go
    end

    it "should eliminate players after each round and return ranking" do

      Croupier::Game::Runner.stub(:new).and_return(SpecHelper::DummyClass.new)

      @tournament_state.stub(:number_of_active_players_in_tournament).and_return(2, 2, 1)
      @tournament_state.stub(:next_round!)

      ranking = double("Ranking mock")
      Croupier::SitAndGo::Ranking.stub(:new).and_return(ranking)
      ranking.should_receive(:eliminate).twice
      ranking.should_receive(:add_winner).once

      @runner.start_sit_and_go.should == ranking
    end

  end
end