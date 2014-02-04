require_relative 'spec_helper.rb'

describe Croupier::Player do

  let(:strategy) { SpecHelper::FakeStrategy.new }
  let(:player) { Croupier::Player.new(strategy) }

  describe "#bet_request" do

    it "should delegate calls to the player strategy" do
      strategy.should_receive(:bet_request).with(60, to_call: 20, minimum_raise: 40).and_return(30)

      player.bet_request(60, to_call: 20, minimum_raise: 40).should == 30
    end

    it "should respond with forced bet after receiving #force_bet" do
      player.force_bet 20
      player.bet_request(0, {}).should == 20
    end

    it "should delegate bet_request after forced bet has been posted" do
      player.force_bet 20
      strategy.should_receive(:bet_request).with(60, to_call: 20, minimum_raise: 40).and_return(30)

      player.bet_request(0, {}).should == 20
      player.bet_request(60, to_call: 20, minimum_raise: 40).should == 30
    end
  end

  describe "#hole_card" do
    it "should delegate calls to the player strategy" do
      card = PokerRanking::Card::by_name('6 of Diamonds')

      strategy.should_receive(:hole_card).with(card)

      player.hole_card card
    end

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

  describe "#data" do
    context "when a new player is created" do
      it "should return it's state" do
        Croupier::Player.new(nil).data.should == {stack: 1000, active: true, total_bet: 0, hole_cards: []}
      end
    end

    context "when player has cards" do
      it "should also return the cards" do
        subject = Croupier::Player.new(SpecHelper::DummyClass.new)
        hole_card = PokerRanking::Card::by_name('King of Diamonds')
        subject.hole_card(hole_card)
        subject.data.should == {stack: 1000, active: true, total_bet: 0, hole_cards: [hole_card.data]}
      end
    end
  end
end