class SpecHelper::MakeTournamentState
  def self.with(options)
    game_state = Croupier::Tournament::State.new
    players = options[:players] || []
    spectators = options[:logger] || []

    players.each do |player|
      game_state.register_player(player)
    end
    if spectators.length > 0
      spectators.each do |spectator|
        game_state.set_logger(spectator)
      end
    else
      game_state.set_logger SpecHelper::DummyClass.new
    end

    game_state
  end
end