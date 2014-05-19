require_relative 'mustache_base'

class Game < MustacheBase
  attr_reader :game_json
  attr_reader :log

  def initialize(log)
    @log = log
    @game_json = File.read("#{BASE_DIR}#{log}.json")
  end

  def tweets
    VisualSpectator::Twitter.new.tweets
  end

  def chart_data
    data = JSON.parse(@game_json)
    header = ['Round'] + data[0]['game_state']['players'].map { |player| player['name'] }
    rounds = data
    .each_with_index
    .select { |record, _| not record.key? 'type' }
    .map { |round, index| [index] + round['game_state']['players'].map { |player| player['stack'] } }
    JSON.generate([header] + rounds)
  end
end