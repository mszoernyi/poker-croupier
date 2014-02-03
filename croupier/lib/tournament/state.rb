class Croupier::Tournament::State

  def initialize
    @state = {
        players: [],
        spectators: [],
        small_blind: 10,
        orbits: 0,
        current_player: 0,
        dealers_position: 0
    }
  end

  def players
    @state[:players]
  end

  def spectators
    @state[:spectators]
  end

  def small_blind
    @state[:small_blind] * (2**((@state[:orbits]/3).floor))
  end

  def big_blind
    small_blind * 2
  end

  def register_player(player)
    @state[:players] << player
  end

  def register_spectator(spectator)
    @state[:spectators] << spectator
  end

  def deck
    @state[:deck] ||= Croupier::Deck.new
  end

  def each_observer
    (@state[:players] + @state[:spectators]).each do |observer|
      yield observer
    end
  end

  def each_spectator
    @state[:spectators].each do |observer|
      yield observer
    end
  end

  def each_player
    @state[:players].each do |observer|
      yield observer
    end
  end

  def each_player_from(from_player)
    @state[:players].rotate(@state[:players].index(from_player)).each do |observer|
      yield observer
    end
  end

  def dealer
    @state[:players][@state[:dealers_position]]
  end

  def first_player
    @state[:players][nth_player_index 1]
  end

  def second_player
    @state[:players][nth_player_index 2]
  end

  def number_of_active_players_in_tournament
    @state[:players].count { |player| player.has_stack? }
  end

  def players_eliminated
    @state[:players].rotate(@state[:players].index(first_player)).select { |player| not player.has_stack? }
  end

  def active_players
    @state[:players].select { |player| player.has_stack? }
  end

  def next_round!
    @state[:players].each do |player|
      player.initialize_round
    end

    move_deal_button_to_next_active_player
  end

  private

  def move_deal_button_to_next_active_player
    previous_dealer = @state[:dealers_position]

    @state[:dealers_position] = nth_player_index 1

    if previous_dealer > @state[:dealers_position]
      @state[:orbits] += 1
    end
  end

  def nth_player_index(n)
    player_index = @state[:dealers_position]
    while n > 0
      player_index = (player_index + 1) % players.count
      n -= 1 if @state[:players][player_index].has_stack?
    end
    player_index
  end
end
