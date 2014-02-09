
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
    req = Net::HTTP::Post.new(@path)#, initheader = {'Content-Type' =>'application/json'})
    req.set_form({ action: 'bet_request', game_state: game_state.to_json })
    response = Net::HTTP.new(@host, @port).start {|http| http.request(req) }

    return response.body.to_i if response.code == 200

    0
  end

  def open
  end

  def close
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