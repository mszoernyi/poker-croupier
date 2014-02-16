require 'json'

class Croupier::LogHandler::Json

  def initialize(file)
    @history = []
    @file = file
    @dealer = -1
    @message_generator = Croupier::LogHandler::Messages.new
  end

  def initialize_state
    @dealer += 1
    @game_phase = :start
    @state = {
        pot: 0,
        dealer: '',
        on_turn: '',
        message: '',
        community_cards: [],
        players: [],
    }
    @player_index = {}
  end

  def competitor_status(competitor)
    unless @game_phase == :start
      initialize_state
    end

    @game_phase = :start
    index = @state[:players].length
    @player_index[competitor.name] = index
    @state[:players] << {
        id: index,
        name: competitor.name,
        stack: competitor.stack,
        bet: 0,
        status: ((competitor.stack > 0) ? 'active' : 'out'),
        hole_cards: []
    }
  end

  def bet(competitor, bet)
    @state[:message] = @message_generator.bet(competitor, bet)
    @state[:on_turn] = @player_index[competitor.name]
    @state[:pot] = bet[:pot]
    json_player(competitor)[:stack] = competitor.stack
    json_player(competitor)[:bet] += bet[:amount]
    json_player(competitor)[:status] = "folded" if bet[:type] == :fold
    save_step
  end


  def showdown(competitor, hand)
    @state[:on_turn] = @player_index[competitor.name]
    @state[:message] = @message_generator.showdown(competitor, hand)
    save_step
  end

  def winner(competitor, amount)
    @state[:on_turn] = @player_index[competitor.name]
    @state[:message] = @message_generator.winner(competitor, amount)
    @game_phase = :end
    @state[:pot] -= amount
    json_player(competitor)[:stack] += amount
    save_step
  end

  def flush
    File.open(@file, 'w') do |file|
      file.puts "[" + @history.join(",\n") + "]"
    end
  end

  def log_state(game_state, message = '')
    @state = game_state
    @state['message'] = message
    save_step

    refresh_player_index(game_state)
  end

  private

  def refresh_player_index(game_state)
    @player_index = {}
    game_state[:players].each_with_index do |player, index|
      @player_index[player[:name]] = index
    end
  end

  def json_player(competitor)
    @state[:players][@player_index[competitor.name]]
  end

  def format_card(card)
    rank = card.value
    if card.value > 10
      rank = ["J","Q","K","A"][card.value - 11]
    end
    {rank: rank, suit: card.suit.downcase}
  end

  def save_step
    @history << JSON.generate(@state)
  end
end
