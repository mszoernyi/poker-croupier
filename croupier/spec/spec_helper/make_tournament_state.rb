class SpecHelper::MakeTournamentState
  def self.with(options)
    game_state = Croupier::SitAndGo::State.new
    players = options[:players] || []

    players.each do |player|
      game_state.register_player(player)
    end

    game_state
  end
end