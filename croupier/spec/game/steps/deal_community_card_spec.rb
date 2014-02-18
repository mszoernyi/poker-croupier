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
    )

    @game_state = Croupier::Game::State.new tournament_state
  end

  it "should store the card dealt in game_state for later use" do
    run

    @game_state.community_cards.should == [@cards.first]
  end

  it "should log the game state" do
    @game_state.should_receive(:log_state).with(message: "community card #{@cards.first}")

    run
  end

  it "should skip dealing if there is only one active player" do
    @game_state.players[0].fold

    run

    @game_state.community_cards.should == []
  end

end