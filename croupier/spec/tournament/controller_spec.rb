require_relative '../spec_helper'



describe Croupier::Tournament::Controller do

  def register_test_player(name)
    strategy = SpecHelper::DummyClass.new
    subject.register_rest_player name, strategy
    strategy
  end

  context "there are two players" do
    let(:player1_strategy) { register_test_player('Player 1') }
    let(:player2_strategy) { register_test_player('Player 2') }
    let(:sit_and_go_controller_mock) { double }

    before :each do
      Croupier::SitAndGo::Controller.stub(:new).and_return sit_and_go_controller_mock
    end

    def expect_a_round_of_sit_and_go
      sit_and_go_controller_mock.should_receive(:register_rest_player).with('Player 1', player1_strategy)
      sit_and_go_controller_mock.should_receive(:register_rest_player).with('Player 2', player2_strategy)
      sit_and_go_controller_mock.should_receive(:start_sit_and_go)
    end

    it "should run a sit and go" do
      expect_a_round_of_sit_and_go

      subject.start_tournament max_iterations: 1
    end

    it "should run the sit and go multiple times" do
      expect_a_round_of_sit_and_go
      expect_a_round_of_sit_and_go

      subject.start_tournament max_iterations: 2
    end
  end



end