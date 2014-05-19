class VisualSpectator::Tournament
  attr_reader :games

  def initialize(data)
    @games = []
    data.each_with_index do |game, index|
      @games << VisualSpectator::Game.new(game, self, index)
    end
  end

  def players
    @games.last.players
  end
end