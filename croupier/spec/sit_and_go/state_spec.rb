require_relative '../spec_helper'

describe Croupier::SitAndGo::State do
  describe "#register_player" do
    it "should add the player to the list of players" do
      first_player = double("First player")
      second_player = double("Second player")

      game_state = Croupier::SitAndGo::State.new
      game_state.register_player(first_player)
      game_state.register_player(second_player)

      expect(game_state.players).to eq([first_player, second_player])
    end
  end

  describe "#number_of_players_in_game" do
    it "should return the number of players who have stacks" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      expect(game_state.number_of_active_players_in_tournament).to eq(1)
    end
  end

  describe "#players_eliminated" do
    it "should return all players without chips" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      expect(game_state.players_eliminated).to eq([game_state.players[0]])
    end

    it "should return the current first player first" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player, fake_player]
      game_state.players[0].stack = 0
      game_state.players[1].stack = 0

      expect(game_state.players_eliminated).to eq([game_state.players[0], game_state.players[1]])
    end
  end

  describe "#active_players" do
    it "should return active players" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      expect(game_state.active_players).to eq([game_state.players[1]])
    end
  end

  describe "#set_logger" do
    it "should replace the default logger" do
      logger = double("Logger")

      game_state = Croupier::SitAndGo::State.new
      game_state.set_logger(logger)

      expect(game_state.logger).to eq(logger)
    end
  end

  describe "#next_round" do
    let(:game_state) {
      tournament_state = SpecHelper::MakeTournamentState.with(players: [fake_player('a'), fake_player('b'), fake_player('c')])

      Croupier::Game::State.new tournament_state
    }

    it "should double the blinds when the dealer button returns to the first player for the third time" do
      small_blind_at_start = game_state.small_blind
      big_blind_at_start = game_state.big_blind

      8.times do |_|
        game_state.next_round!
        expect(game_state.small_blind).to eq(small_blind_at_start)
        expect(game_state.big_blind).to eq(big_blind_at_start)
      end

      game_state.next_round!
      expect(game_state.small_blind).to eq(small_blind_at_start * 2)
      expect(game_state.big_blind).to eq(big_blind_at_start * 2)

    end

    it "should double blinds even if player[0] is inactive" do
      small_blind_at_start = game_state.small_blind
      big_blind_at_start = game_state.big_blind

      game_state.next_round!
      game_state.players[0].stack = 0
      8.times { |_| game_state.next_round! }

      expect(game_state.small_blind).to eq(small_blind_at_start * 2)
      expect(game_state.big_blind).to eq(big_blind_at_start * 2)
    end

    it "should reactivate folded players with non zero stacks" do
      expect(game_state.players[0]).to receive(:initialize_round)
      expect(game_state.players[2]).to receive(:initialize_round)

      game_state.next_round!
    end

    it "should skip in-active players when moving the dealer button" do
      game_state.players[1].stack = 0
      game_state.next_round!
      expect(game_state.dealer).to eq(game_state.players[2])

    end
  end

  describe "Calculate index of special players" do
    before :each do
      @game_state = Croupier::SitAndGo::State.new

      5.times do |c|
        @game_state.register_player fake_player
      end
    end

    it "should calculate the first player" do
      @game_state.first_player == @game_state.players[1]

      @game_state.next_round!
      expect(@game_state.first_player).to eq(@game_state.players[2])

      @game_state.next_round!
      @game_state.next_round!
      expect(@game_state.first_player).to eq(@game_state.players[4])

      @game_state.next_round!
      expect(@game_state.first_player).to eq(@game_state.players[0])
    end

    it "should calculate the second player" do
      @game_state.second_player == @game_state.players[2]

      @game_state.next_round!
      @game_state.next_round!
      @game_state.next_round!
      expect(@game_state.second_player).to eq(@game_state.players[0])

      @game_state.next_round!
      expect(@game_state.second_player).to eq(@game_state.players[1])
    end

    it "should skip inactive players" do
      @game_state.players[1].stack = 0
      @game_state.players[3].stack = 0

      expect(@game_state.first_player).to eq(@game_state.players[2])
    end
  end

  context "iterators" do
    before :each do
      @game_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player],
      )
    end

    describe "#each_player" do
      it "should yield each player" do
        players = []
        @game_state.each_player do |player|
          players << player
        end

        expect(players).to eq(@game_state.players)
      end
    end

    describe "#each_player_from" do
      it "should yield each player, starting with the second_player" do
        players = []
        @game_state.each_player_from @game_state.second_player do |player|
          players << player
        end

        expect(players).to eq(@game_state.players)
      end

      it "should yield each player, starting with the first_player" do
        players = []
        @game_state.each_player_from @game_state.first_player do |player|
          players << player
        end

        expect(players).to eq([@game_state.players[1], @game_state.players[0]])
      end
    end
  end

  describe "#data" do
    context "when a new tournament is created" do
      it "should return the tournament state" do
        expect(subject.data).to eq({players: [], small_blind: 10, orbits: 0, dealer: 0})
      end
    end

    context "when a player is added" do
      it "should add the players data to the result" do
        strategy = SpecHelper::DummyClass.new
        allow(strategy).to receive(:name).and_return("Joe")
        subject.register_player Croupier::Player.new(strategy)
        expect(subject.data).to eq({
            players: [{id: 0, name: "Joe", stack: 1000, status: "active", bet: 0, hole_cards: [], version: nil}],
            small_blind: 10, 
            orbits: 0, 
            dealer: 0
        })
      end
    end
  end
end