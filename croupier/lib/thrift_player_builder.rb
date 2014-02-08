require 'player_strategy'

class Croupier::ThriftPlayerBuilder

  def build_player(address)
    Croupier::Player.new(Croupier::ThriftPlayer.new(*build_client(address)))
  end

  private

  def build_client(address)

    if /^[\w\d\.]+:\d+$/ =~ address
      host, port = address.split(':')
      socket = Thrift::Socket.new(host, port)
    else
      socket = Thrift::HTTPClientTransport.new(address)
    end

    transport = Thrift::BufferedTransport.new(socket)
    protocol = Thrift::BinaryProtocol.new(transport)
    strategy = API::PlayerStrategy::Client.new(protocol)
    [strategy, transport]
  end
end