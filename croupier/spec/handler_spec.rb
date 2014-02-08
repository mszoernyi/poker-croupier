require_relative 'spec_helper.rb'

describe Croupier::Handler do
  describe "#register_thrift_player" do
    let(:player_builder) { double('PlayerBuilder') }
    let(:player) { double('Player') }
    let(:croupier) { double('Croupier') }
    let(:logger_mock) { double('Logger') }

    before(:each) do
      Croupier::ThriftPlayerBuilder.stub(:new).and_return(player_builder)
      Croupier::Tournament::Runner.stub(:new).and_return(croupier)
      Croupier.stub(:logger).and_return(logger_mock)
      croupier.stub(:register_spectator)
    end

    context "connection successful" do
      before(:each) do
        player_builder.should_receive(:build_player).with('some.host:10001').and_return(player)
      end

      it "should register player when connection is successful and log an info message" do

        croupier.should_receive(:register_player).with(player)
        player.should_receive(:open)
        player.should_receive(:name).and_return('Joe')
        logger_mock.should_receive(:info).with('Connected Joe at some.host:10001')

        Croupier::Handler.new.register_thrift_player('some.host:10001')
      end
    end

    context "connection was not successful" do
      before(:each) do
        player_builder.should_receive(:build_player).with('some.host:10001').and_raise(StandardError, 'Connection failed')
      end

      it "should not register the player and log an error message" do
        croupier.should_not_receive(:register_thrift_player).with(player)
        logger_mock.should_receive(:error).with('Connection failed')

        expect{ Croupier::Handler.new.register_thrift_player('some.host:10001') }.to raise_error(StandardError, 'Connection failed')
      end
    end

  end
end