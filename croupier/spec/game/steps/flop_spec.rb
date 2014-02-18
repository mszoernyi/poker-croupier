require_relative '../../spec_helper.rb'



describe Croupier::Game::Steps::DealFlop do
  def run
    Croupier::Game::Steps::DealFlop.new(@game_state).run
  end

  before(:each) do
    @cards = ['6 of Diamonds', 'Jack of Hearts', 'Ace of Spades', 'King of Clubs'].map { |name| PokerRanking::Card::by_name name }

    @deck = double("Deck")
    @deck.stub(:next_card!).and_return(*@cards)

    Croupier::Deck.stub(:new).and_return(@deck)

    tournament_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player],
    )

    @game_state = Croupier::Game::State.new tournament_state
  end

  it "should deal three community cards" do
    run

    @game_state.community_cards.should == @cards[0..2]
  end
end
