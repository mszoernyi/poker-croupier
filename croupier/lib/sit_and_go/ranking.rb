class Croupier::SitAndGo::Ranking
  def initialize(state)
    @state = state
    @ranking = []
  end

  def get
    @ranking
  end

  def eliminate
    @state.players_eliminated.each do |player|
      unless @ranking.include?(player)
        @ranking << player
      end
    end
  end

  def add_winner
    @ranking.concat(@state.active_players)
  end
end