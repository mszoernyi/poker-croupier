require_relative '../../spec_helper'
require 'card'

describe Croupier::Game::Steps::DealCommunityCard do
  def run
    Croupier::Game::Steps::DealCommunityCard.new(@game_state).run
  end

  before(:each) do
    @cards = ['6 of Diamonds', 'Jack of Hearts'].map { |name| PokerRanking::Card::by_name name }

    @deck = double("Deck")
    @deck.stub(:next_card!).and_return(*@cards)

    Croupier::Deck.stub(:new).and_return(@deck)

    tournament_state = SpecHelper::MakeTournamentState.with(
        players: [fake_player, fake_player],
        spectators: [SpecHelper::FakeSpectator.new, SpecHelper::FakeSpectator.new]
    )

    @game_state = Croupier::Game::State.new tournament_state
  end

  it "should skip dealing if there is only one active player" do
    @game_state.players[0].fold
    @game_state.players[1].should_not_receive(:community_card)

    run
  end

  it "should deal a community card and notify the players" do
    @game_state.players.each do |player|
      player.should_receive(:community_card).with(@cards.first)
    end

    run
  end

  it "should deal a community card and notify the spectators" do
    @game_state.spectators.each do |spectator|
      spectator.should_receive(:community_card).with(@cards.first)
    end

    run
  end

  it "should store the card dealt in game_state for later use" do
    run

    @game_state.community_cards.should == [@cards.first]
  end
end