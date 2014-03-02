class Croupier::SitAndGo::State
  attr_reader :players
  attr_reader :logger

  def initialize
    @players = []
    @logger = Croupier::LogHandler::NilLogger.new
    @small_blind = 10
    @orbits = 0
    @dealers_position = 0
    @rounds = 0
  end

  def select_dealer_randomly
    @dealers_position = rand(players.length)
  end

  def small_blind
    @small_blind * (2**((@orbits/3).floor))
  end

  def big_blind
    small_blind * 2
  end

  def register_player(player)
    @players << player
  end

  def set_logger(logger)
    @logger = logger
  end

  def log_state(additional_data = {})
    @logger.log_state(data, additional_data)
  end

  def flush_log
    @logger.flush
  end

  def deck
    @deck ||= Croupier::Deck.new
  end

  def each_player
    @players.each do |player|
      yield player
    end
  end

  def each_player_from(from_player)
    @players.rotate(@players.index(from_player)).each do |player|
      yield player
    end
  end

  def dealer
    @players[@dealers_position]
  end

  def first_player
    @players[nth_player_index 1]
  end

  def second_player
    @players[nth_player_index 2]
  end

  def number_of_active_players_in_tournament
    @players.count { |player| player.has_stack? }
  end

  def players_eliminated
    @players.rotate(@players.index(first_player)).select { |player| not player.has_stack? }
  end

  def active_players
    @players.select { |player| player.has_stack? }
  end

  def next_round!
    @players.each do |player|
      player.initialize_round
    end

    move_deal_button_to_next_active_player
  end

  def data
    {
      players: @players.each_with_index.map { |player, index| player.data.merge({ id: index }) },
      small_blind: @small_blind,
      orbits: @orbits,
      dealer: @dealers_position
    }
  end

  def players_running?
    @players.each do |player|
      return false unless player.running?
    end

    true
  end

  private

  def move_deal_button_to_next_active_player
    previous_dealer = @dealers_position

    @dealers_position = nth_player_index 1

    @rounds += 1
    @orbits = (@rounds/players.length).floor
  end

  def nth_player_index(n)
    player_index = @dealers_position
    while n > 0
      player_index = (player_index + 1) % players.count
      n -= 1 if @players[player_index].has_stack?
    end
    player_index
  end
end
