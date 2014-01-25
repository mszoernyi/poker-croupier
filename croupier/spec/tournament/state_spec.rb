require_relative '../spec_helper'

describe Croupier::Tournament::State do
  describe "#register_player" do
    it "should add the player to the list of players" do
      first_player = double("First player")
      second_player = double("Second player")

      game_state = Croupier::Tournament::State.new
      game_state.register_player(first_player)
      game_state.register_player(second_player)

      game_state.players.should == [first_player, second_player]
    end
  end

  describe "#number_of_players_in_game" do
    it "should return the number of players who have stacks" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      game_state.number_of_active_players_in_tournament.should == 1
    end
  end

  describe "#players_eliminated" do
    it "should return all players without chips" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      game_state.players_eliminated.should == [game_state.players[0]]
    end

    it "should return the current first player first" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player, fake_player]
      game_state.players[0].stack = 0
      game_state.players[1].stack = 0

      game_state.players_eliminated.should == [game_state.players[0], game_state.players[1]]
    end
  end

  describe "#active_players" do
    it "should return active players" do
      game_state = SpecHelper::MakeTournamentState.with players: [fake_player, fake_player]
      game_state.players[0].stack = 0

      game_state.active_players.should == [game_state.players[1]]
    end
  end

  describe "#register_spectator" do
    it "should add tge spectator to the list of spectators" do
      spectator = double("Spectator")

      game_state = Croupier::Tournament::State.new
      game_state.register_spectator(spectator)

      game_state.spectators.should == [spectator]
    end
  end

  describe "#send_message_to_everyone" do
    it "should send the messages to each player" do
      game_state = SpecHelper::MakeTournamentState.with players: [double("First player"), double("Second player")]

      game_state.players.each do |player|
        player.should_receive(:the_message)
      end

      game_state.each_observer do |observer|
        observer.the_message
      end
    end

    it "should send the messages to all spectators" do
      game_state = SpecHelper::MakeTournamentState.with spectators: [double("First spectator"), double("Second spectator")]

      game_state.spectators.each do |spectator|
        spectator.should_receive(:the_message)
      end

      game_state.each_observer do |observer|
        observer.the_message
      end
    end
  end

  describe "#send_message_to_spectators" do
    it "should not send the messages to the players" do
      game_state = SpecHelper::MakeTournamentState.with players: [double("First player"), double("Second player")]

      game_state.each_spectator do |observer|
        observer.the_message
      end
    end

    it "should send the messages to all spectators" do
      game_state = SpecHelper::MakeTournamentState.with(
          players: [double("First player"), double("Second player")],
          spectators: [double("First spectator"), double("Second spectator")]
      )

      game_state.spectators.each do |spectator|
        spectator.should_receive(:the_message)
      end

      game_state.each_spectator do |observer|
        observer.the_message
      end
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
        game_state.small_blind.should == small_blind_at_start
        game_state.big_blind.should == big_blind_at_start
      end

      game_state.next_round!
      game_state.small_blind.should == small_blind_at_start * 2
      game_state.big_blind.should == big_blind_at_start * 2

    end

    it "should double blinds even if player[0] is inactive" do
      small_blind_at_start = game_state.small_blind
      big_blind_at_start = game_state.big_blind

      game_state.next_round!
      game_state.players[0].stack = 0
      8.times { |_| game_state.next_round! }

      game_state.small_blind.should == small_blind_at_start * 2
      game_state.big_blind.should == big_blind_at_start * 2
    end

    it "should reactivate folded players with non zero stacks" do
      game_state.players[0].should_receive(:initialize_round)
      game_state.players[2].should_receive(:initialize_round)

      game_state.next_round!
    end

    it "should skip in-active players when moving the dealer button" do
      game_state.players[1].stack = 0
      game_state.next_round!
      game_state.dealer.should == game_state.players[2]

    end
  end

  describe "Calculate index of special players" do
    before :each do
      @game_state = Croupier::Tournament::State.new

      5.times do |c|
        @game_state.register_player fake_player
      end
    end

    it "should calculate the first player" do
      @game_state.first_player == @game_state.players[1]

      @game_state.next_round!
      @game_state.first_player.should == @game_state.players[2]

      @game_state.next_round!
      @game_state.next_round!
      @game_state.first_player.should == @game_state.players[4]

      @game_state.next_round!
      @game_state.first_player.should == @game_state.players[0]
    end

    it "should calculate the second player" do
      @game_state.second_player == @game_state.players[2]

      @game_state.next_round!
      @game_state.next_round!
      @game_state.next_round!
      @game_state.second_player.should == @game_state.players[0]

      @game_state.next_round!
      @game_state.second_player.should == @game_state.players[1]
    end

    it "should skip inactive players" do
      @game_state.players[1].stack = 0
      @game_state.players[3].stack = 0

      @game_state.first_player.should == @game_state.players[2]
      #@game_state.second_player.should == @game_state.players[2]
    end
  end

  context "iterators" do
    before :each do
      @game_state = SpecHelper::MakeTournamentState.with(
          players: [fake_player, fake_player],
          spectators: [SpecHelper::FakeSpectator.new, SpecHelper::FakeSpectator.new]
      )
    end

    describe "#each_player" do
      it "should yield each player" do
        players = []
        @game_state.each_player do |player|
          players << player
        end

        players.should == @game_state.players
      end
    end

    describe "#each_player_from" do
      it "should yield each player, starting with the second_player" do
        players = []
        @game_state.each_player_from @game_state.second_player do |player|
          players << player
        end

        players.should == @game_state.players
      end

      it "should yield each player, starting with the first_player" do
        players = []
        @game_state.each_player_from @game_state.first_player do |player|
          players << player
        end

        players.should == [@game_state.players[1], @game_state.players[0]]
      end
    end

    describe "#each_spectator" do
      it "should yield each spectator" do
        spectators = []
        @game_state.each_spectator do |spectator|
          spectators << spectator
        end

        spectators.should == @game_state.spectators
      end
    end

    describe "#each_player_and_spectator" do
      it "should yield each player and spectator" do
        observers = []
        @game_state.each_observer do |observer|
          observers << observer
        end

        observers.should == @game_state.players + @game_state.spectators
      end
    end
  end
end