class VisualSpectator::Tournament
  attr_reader :games

  def initialize(data)
    @games = []
    data.each_with_index do |game, index|
      @games << VisualSpectator::Game.new(game, trend_reference(index))
    end
  end

  def trend_reference(index)
    @games[[0, index - 20].max]
  end

  def players
    @games.last.players
  end
end