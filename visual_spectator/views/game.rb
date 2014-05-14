require_relative 'mustache_base'

class Game < MustacheBase
  attr_reader :game_json
  attr_reader :log

  def initialize(log)
    @log = log
    @game_json = File.read("#{BASE_DIR}#{log}.json")
  end

  def tweets
    config_file = File.dirname(__FILE__) + '/twitter_api.yml'
    return "[]" unless FileTest.exist? config_file

    twitter_config = YAML.load(File.open(config_file).read)

    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key = twitter_config['key']
        config.consumer_secret = twitter_config['secret']
      end

      JSON.generate(client.search(twitter_config['search'], rpp: 10, result_type: 'recent').take(10).map do |tweet|
        {
            profile_image: tweet.user.profile_image_url.to_s,
            username: tweet.user.username,
            text: tweet.text
        }
      end)
    rescue
      "[]"
    end
  end

  def chart_data
    data = JSON.parse(@game_json)#.
    header = ['Round'] + data[0]['game_state']['players'].map { |player| player['name'] }
    rounds = data
    .each_with_index
    .select { |record, index| not record.key? 'type' }
    .map { |round, index| [index] + round['game_state']['players'].map { |player| player['stack'] } }
    JSON.generate([header] + rounds)
  end
end