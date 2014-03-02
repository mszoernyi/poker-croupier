class Croupier::RandomPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def bet_request(game_state)
    to_call = game_state[:current_buy_in] - game_state[:players][game_state[:in_action]][:bet]
    case rand(0..4)
      when 0
        0
      when 1
        to_call + game_state[:minimum_raise] * rand(1..4)
      else
        to_call
    end
  end

  def showdown(game_state)

  end

  def running?
    true
  end
end