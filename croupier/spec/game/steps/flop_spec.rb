require_relative '../../spec_helper.rb'



describe Croupier::Game::Steps::DealFlop do
  def run
    Croupier::Game::Steps::DealFlop.new(@game_state).run
  end

  before(:each) do
    @cards = ['6 of Diamonds', 'Jack of Hearts', 'Ace of Spades', 'King of Clubs'].map { |name| PokerRanking::Card::by_name name }

    @deck = double("Deck")
    allow(@deck).to receive(:next_card!).and_return(*@cards)

    allow(Croupier::Deck).to receive(:new).and_return(@deck)

    tournament_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player],
    )

    @game_state = Croupier::Game::State.new tournament_state
  end

  it "should deal three community cards" do
    run

    expect(@game_state.community_cards).to eq(@cards[0..2])
  end
end
