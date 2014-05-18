
class VisualSpectator::Tournament
  attr_reader :games

  def initialize(data)
    @games = []
    data.each_with_index do |game, index|
      trend_reference = @games[[0, index - 20].max]
      p "#{index} - #{[0, index - 20].max}"
      @games << VisualSpectator::Game.new(game, trend_reference)
    end
  end
end