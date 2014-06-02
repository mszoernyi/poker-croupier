require_relative '../../spec_helper'
require 'card'

describe Croupier::Game::Steps::DealCommunityCard do
  def run
    Croupier::Game::Steps::DealCommunityCard.new(@game_state).run
  end

  before(:each) do
    @cards = ['6 of Diamonds', 'Jack of Hearts'].map { |name| PokerRanking::Card::by_name name }

    @deck = double("Deck")
    allow(@deck).to receive(:next_card!).and_return(*@cards)

    allow(Croupier::Deck).to receive(:new).and_return(@deck)

    tournament_state = SpecHelper::MakeTournamentState.with(
        players: [fake_player, fake_player],
    )

    @game_state = Croupier::Game::State.new tournament_state
  end

  it "should store the card dealt in game_state for later use" do
    run

    expect(@game_state.community_cards).to eq([@cards.first])
  end

  it "should log the game state" do
    expect(@game_state).to receive(:log_state).with(type: 'card_deal', message: "community card #{@cards.first}")

    run
  end

  it "should skip dealing if there is only one active player" do
    @game_state.players[0].fold

    run

    expect(@game_state.community_cards).to eq([])
  end

end