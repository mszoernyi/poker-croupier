require_relative 'spec_helper.rb'

describe Croupier::Player do

  let(:strategy) { SpecHelper::FakeStrategy.new }
  let(:player) { Croupier::Player.new(strategy) }

  let(:game_state) { Croupier::Game::State.new(SpecHelper::MakeTournamentState::with({})) }

  describe "#bet_request" do

    it "should delegate calls to the player strategy" do
      expect(strategy).to(receive(:bet_request).with(game_state).and_return(30))

      expect(player.bet_request(game_state)).to eq(30)
    end

    it "should respond with forced bet after receiving #force_bet" do
      player.force_bet 20
      expect(player.bet_request(game_state)).to eq(20)
    end

    it "should delegate bet_request after forced bet has been posted" do
      player.force_bet 20
      expect(strategy).to(receive(:bet_request).with(game_state).and_return(30))

      expect(player.bet_request(game_state)).to eq(20)
      expect(player.bet_request(game_state)).to eq(30)
    end
  end

  describe "#hole_card" do
    it "should store hole cards for later use" do
      card1 = PokerRanking::Card::by_name('6 of Diamonds')
      card2 = PokerRanking::Card::by_name('King of Spades')

      player.hole_card card1
      player.hole_card card2

      expect(player.hole_cards).to eq([card1, card2])
    end
  end

  describe "#initialize_round" do
    it "should reset values related to a single round of poker" do
      player.fold
      player.total_bet = 100
      player.hole_cards << "Ace of spades"

      player.initialize_round

      expect(player.active?).to be_truthy
      expect(player.allin?).to be_falsey
      expect(player.total_bet).to eq(0)
      expect(player.hole_cards).to eq([])
    end

    it "should not reactivate player if it has no chips left" do
      player.fold
      player.stack = 0

      player.initialize_round

      expect(player.active?).to be_falsey
    end

    it "should deactivate player if it has no chips left" do
      player.stack = 0

      player.initialize_round

      expect(player.active?).to be_falsey
    end
  end

  describe "#out?" do
    context "when the player has stack" do
      it "should return false" do
        expect(player.out?).to be_falsey
      end
    end

    context "when the player is all in" do
      it "should return false" do
        player.stack = 0
        player.total_bet = 1000
        expect(player.out?).to be_falsey
      end
    end

    context "when has no money left" do
      it "should return true" do
        player.stack = 0
        player.total_bet = 0
        expect(player.out?).to be_truthy
      end
    end
  end

  describe "#data" do
    let(:strategy) {
      SpecHelper::DummyClass.new.tap { |strategy| allow(strategy).to receive(:name).and_return("Joe") }
    }
    let(:subject) {
      Croupier::Player.new(strategy)
    }

    context "when a new player is created" do
      it "should return it's state" do
        expect(Croupier::Player.new(strategy).data).to eq({name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil})
      end
    end

    context "when player has cards" do
      it "should also return the cards" do
        hole_card = PokerRanking::Card::by_name('King of Diamonds')
        subject.hole_card(hole_card)
        expect(subject.data).to eq({name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [hole_card.data], version: nil})
      end
    end

    context "when player folded" do
      it "should set status to 'folded'" do
        player = Croupier::Player.new(strategy)
        player.fold
        expect(player.data).to eq({name: "Joe", stack: 1000, status: "folded", bet: 0, hole_cards: [], version: nil})
      end
    end

    context "when player is out" do
      it "should set status to 'out'" do
        player = Croupier::Player.new(strategy)
        player.stack = 0
        expect(player.data).to eq({name: "Joe", stack: 0, status: "out", bet: 0, hole_cards: [], version: nil})
      end
    end
  end
end