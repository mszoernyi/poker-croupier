
require 'net/http'
require 'json'
require 'uri'

class Croupier::RestPlayer

  attr_reader :name

  def initialize(name, url)
    @name = name
    @url = url
    @version = nil
  end

  def bet_request(game_state)
    send_request action: 'bet_request', game_state: game_state.to_json  do |error, result|
      if error
        raise Croupier::PlayerUnreachable.new
      end

      result.to_i
    end
  end

  def showdown(game_state)
    send_request action: 'showdown', game_state: game_state.to_json
  end

  def version
    if @version.nil?
      send_request action: 'version' do |error, result|
        if error
          return 'Unknown'
        end

        @version = result
      end
    end

    @version
  end

  def running?
    send_request action: 'check' do |error, _|
      return !error
    end
  end

  private

  def send_request(message, &block)
    Croupier::HttpRequestLight.post(@url, message) do |error, response|
      if error
        if response[:code] == 0
          Croupier::logger.error "Player #{name} is unreachable: '#{response[:message]}'"
          yield true, nil if block_given?
        else
          Croupier::logger.error "Player #{name} responded with #{response[:message]} (#{response[:code]})"
          yield true, nil if block_given?
        end
      else
        Croupier::logger.info "Player #{name} responded with #{response[:message]} (#{response[:code]})"
        yield false, response[:message] if block_given?
      end
    end
  end
end
