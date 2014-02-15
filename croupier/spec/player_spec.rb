require_relative 'spec_helper.rb'

describe Croupier::Player do

  let(:strategy) { SpecHelper::FakeStrategy.new }
  let(:player) { Croupier::Player.new(strategy) }

  let(:game_state) { Croupier::Game::State.new(SpecHelper::MakeTournamentState::with({})) }

  describe "#bet_request" do

    it "should delegate calls to the player strategy" do
      strategy.should_receive(:bet_request).with(game_state).and_return(30)

      player.bet_request(game_state).should == 30
    end

    it "should respond with forced bet after receiving #force_bet" do
      player.force_bet 20
      player.bet_request(game_state).should == 20
    end

    it "should delegate bet_request after forced bet has been posted" do
      player.force_bet 20
      strategy.should_receive(:bet_request).with(game_state).and_return(30)

      player.bet_request(game_state).should == 20
      player.bet_request(game_state).should == 30
    end
  end

  describe "#hole_card" do
    it "should store hole cards for later use" do
      card1 = PokerRanking::Card::by_name('6 of Diamonds')
      card2 = PokerRanking::Card::by_name('King of Spades')

      player.hole_card card1
      player.hole_card card2

      player.hole_cards.should == [card1, card2]
    end
  end

  describe "#initialize_round" do
    it "should reset values related to a single round of poker" do
      player.fold
      player.total_bet = 100
      player.hole_cards << "Ace of spades"

      player.initialize_round

      player.active?.should be_true
      player.allin?.should be_false
      player.total_bet.should == 0
      player.hole_cards.should == []
    end

    it "should not reactivate player if it has no chips left" do
      player.fold
      player.stack = 0

      player.initialize_round

      player.active?.should be_false
    end

    it "should deactivate player if it has no chips left" do
      player.stack = 0

      player.initialize_round

      player.active?.should be_false
    end
  end

  describe "#out?" do
    context "when the player has stack" do
      it "should return false" do
        player.out?.should == false
      end
    end

    context "when the player is all in" do
      it "should return false" do
        player.stack = 0
        player.total_bet = 1000
        player.out?.should == false
      end
    end

    context "when has no money left" do
      it "should return true" do
        player.stack = 0
        player.total_bet = 0
        player.out?.should == true
      end
    end
  end

  describe "#data" do
    let(:strategy) {
      SpecHelper::DummyClass.new.tap { |strategy| strategy.stub(:name).and_return("Joe") }
    }
    let(:subject) {
      Croupier::Player.new(strategy)
    }

    context "when a new player is created" do
      it "should return it's state" do
        Croupier::Player.new(strategy).data.should == {name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: []}
      end
    end

    context "when player has cards" do
      it "should also return the cards" do
        hole_card = PokerRanking::Card::by_name('King of Diamonds')
        subject.hole_card(hole_card)
        subject.data.should == {name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [hole_card.data]}
      end
    end

    context "when player folded" do
      it "should set status to 'folded'" do
        player = Croupier::Player.new(strategy)
        player.fold
        player.data.should == {name: "Joe", stack: 1000, status: "folded", bet: 0, hole_cards: []}
      end
    end

    context "when player is out" do
      it "should set status to 'out'" do
        player = Croupier::Player.new(strategy)
        player.stack = 0
        player.data.should == {name: "Joe", stack: 0, status: "out", bet: 0, hole_cards: []}
      end
    end
  end
end