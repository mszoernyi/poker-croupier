
class VisualSpectator::Tournament
  attr_reader :games

  def initialize(data)
    @games = data.map { |game| VisualSpectator::Game.new(game) }
  end
end