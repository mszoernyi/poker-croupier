class Croupier::Tournament::Runner

  def initialize
    @tournament_state = Croupier::Tournament::State.new
  end

  def register_player(player)
    @tournament_state.register_player player
  end

  def register_spectator(spectator)
    @tournament_state.register_spectator spectator
  end

  def start_sit_and_go
    ranking = Croupier::Tournament::Ranking.new(@tournament_state)
    while @tournament_state.number_of_active_players_in_tournament >= 2 do
      Croupier::Game::Runner.new.run(@tournament_state)
      ranking.eliminate
      @tournament_state.next_round!
      print '.' if STDOUT.tty?
    end
    puts '' if STDOUT.tty?
    ranking.add_winner
    @tournament_state.each_observer do |observer|
      observer.shutdown
    end
    ranking
  end

end
