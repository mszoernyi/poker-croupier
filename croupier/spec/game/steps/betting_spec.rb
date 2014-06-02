require_relative '../../spec_helper'


describe Croupier::Game::Steps::Betting::Step do
  before :each do
    @player_on_button = Croupier::Player.new fake_player

    @game_state = Croupier::Game::State.new(SpecHelper::MakeTournamentState.with players: [@player_on_button])

    @mocked_pot = 0
  end

  def should_bet(player, amount, type, expected_stack = nil)
    should_try_bet player, amount, amount, type, expected_stack
  end

  def should_try_bet(player, requested_amount, actual_amount, type, expected_stack = nil)
    expected_stack = player.stack - actual_amount if expected_stack.nil?
    @mocked_pot += actual_amount
    expect(player).to receive(:bet_request).and_return(requested_amount)
    index = @game_state.players.index(player)
    expect(@game_state).to receive(:log_state).with(type: 'bet', on_turn: index, message: "#{player.name} made a bet of #{actual_amount} (#{type}) and is left with #{expected_stack} chips. The pot now contains #{@mocked_pot} chips.")
  end

  def run()
    Croupier::Game::Steps::Betting::Step.new(@game_state).run
  end

  context "at least two players" do

    before :each do
      @first_player = Croupier::Player.new fake_player
      @game_state.register_player @first_player
    end

    it "should reset last aggressor" do
      expect(@game_state).to receive(:reset_last_aggressor)
      should_bet(@player_on_button, 0, :check)
      should_bet(@first_player, 0, :check)
      run
    end

    it "should request a bet from the player in action, and the player should remain active" do
      should_bet(@player_on_button, 0, :check)
      should_bet(@first_player, 0, :check)
      run
      expect(@player_on_button.active?).to be_truthy
    end

    it "should transfer a non zero bet to the pot" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 0, :fold
      run
      expect(@game_state.pot).to eq(20)
      expect(@first_player.stack).to eq(980)
    end

    it "should skip betting if one of the two players has already folded" do
      @player_on_button.fold
      run
    end

    it "should skip betting if one of the two players is already all in" do
      @player_on_button.stack = 0
      run
    end

    it "should ask the second player after the first player" do
      should_bet @player_on_button, 0, :check
      should_bet @first_player, 0, :check
      run
    end

    it "should transfer non zero bets to the pot" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 20, :call
      run
      expect(@game_state.pot).to eq(40)
      expect(@player_on_button.stack).to eq(980)
      expect(@first_player.stack).to eq(980)
    end

    it "should ask the first player again if the second raises" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 40, :raise
      should_bet @first_player, 20, :call, 960
      run
      expect(@game_state.pot).to eq(80)
      expect(@player_on_button.stack).to eq(960)
      expect(@first_player.stack).to eq(960)
    end

    it "should interpret a zero bet after a raise as a fold" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 0, :fold
      run
      expect(@game_state.pot).to eq(20)
    end

    it "should mark a folded player inactive" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 0, :fold
      run
      expect(@player_on_button.active?).to be_falsey
    end

    it "should keep track of the total_bet for each player" do
      should_bet @first_player, 20, :raise
      should_bet @player_on_button, 0, :fold
      run
      expect(@first_player.total_bet).to eq(20)
      expect(@player_on_button.total_bet).to eq(0)
    end

    it "should interpret a bet smaller then necessary to call as a fold" do
      should_bet @first_player, 20, :raise
      should_try_bet @player_on_button, 19, 0, :fold

      run

      expect(@game_state.pot).to eq(20)
      expect(@player_on_button.stack).to eq(1000)
      expect(@player_on_button.total_bet).to eq(0)
    end

    it "should interpret a bet smaller than the big blind as a check when no other bet has been place before" do
      should_bet @player_on_button, 0, :check
      should_try_bet @first_player, 19, 0, :check

      run
    end

    it "should interpret a bet smaller than the previous raise as a call" do
      should_bet @first_player, 20, :raise
      should_try_bet @player_on_button, 39, 20, :call

      run

      expect(@game_state.pot).to eq(40)
      expect(@player_on_button.stack).to eq(980)
      expect(@player_on_button.total_bet).to eq(20)
    end

    it "should increase the minimum raise to the current raise if it is larger then the current minimum raise" do
      should_bet @first_player, 60, :raise
      should_try_bet @player_on_button, 119, 60, :call

      run

      expect(@game_state.pot).to eq(120)
      expect(@player_on_button.stack).to eq(940)
      expect(@player_on_button.total_bet).to eq(60)
    end

    it "should increase the minimum raise to the current raise by allin if it is larger then the current minimum raise" do
      @first_player.stack = 60
      should_bet @first_player, 60, :allin
      should_try_bet @player_on_button, 119, 60, :call

      run

      expect(@game_state.pot).to eq(120)
      expect(@player_on_button.stack).to eq(940)
      expect(@player_on_button.total_bet).to eq(60)
    end

    it "should skip inactive players" do
      @second_player = Croupier::Player.new fake_player
      @game_state.register_player @second_player

      should_bet @first_player, 20, :raise
      should_bet @second_player, 0, :fold
      should_bet @player_on_button, 40, :raise
      should_bet @first_player, 20, :call, 960
      run
    end

    it "should skip all-in players" do
      @second_player = Croupier::Player.new fake_player
      @second_player.stack = 10
      @game_state.register_player @second_player

      should_bet @first_player, 20, :raise
      should_bet @second_player, 10, :allin
      should_bet @player_on_button, 40, :raise
      should_bet @first_player, 40, :raise, 940
      should_bet @player_on_button, 20, :call, 940
      run
    end


    context "player has less money then needed to call" do
      before :each do
        @player_on_button.stack = 20
        should_bet @first_player, 100, :raise
      end

      it "should let a player go all in" do
        should_bet @player_on_button, 20, :allin

        run

        expect(@player_on_button.stack).to eq(0)
        expect(@player_on_button.total_bet).to eq(20)

        expect(@game_state.pot).to eq(120)
      end

      it "should treat larger bet as an all in" do
        should_try_bet @player_on_button, 40, 20, :allin

        run

        expect(@player_on_button.stack).to eq(0)
        expect(@player_on_button.total_bet).to eq(20)

        expect(@game_state.pot).to eq(120)

      end
    end



    it "should start with the first_player even after the button has moved" do
      @game_state.next_round!
      first_player, player_on_button = @player_on_button, @first_player

      expect(first_player).to receive(:bet_request).ordered.and_return(0)
      expect(player_on_button).to receive(:bet_request).ordered.and_return(0)

      run
    end

  end

end
