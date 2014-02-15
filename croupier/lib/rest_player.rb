
require 'net/http'
require 'json'
require 'uri'

class Croupier::RestPlayer

  attr_reader :name

  def initialize(name, url)
    @name = name
    uri = URI(url)
    @host, @port, @path = uri.host, uri.port, uri.path
  end

  def hole_card(card)
  end

  def bet_request(game_state)
    begin
      req = Net::HTTP::Post.new(@path)
      req.set_form({ action: 'bet_request', game_state: game_state.to_json })
      http_connection = Net::HTTP.new(@host, @port)
      http_connection.open_timeout = 0.5
      http_connection.read_timeout = 0.5
      response = http_connection.start {|http| http.request(req) }

      return 0 unless response.code.to_i == 200

      response.body.to_i
    rescue
      return 0
    end
  end

  def competitor_status(competitor)
  end

  def bet(competitor, bet)
  end

  def community_card(card)
  end

  def showdown(competitor, hand)
  end

  def winner(competitor, amount)
  end

  def shutdown
  end

end