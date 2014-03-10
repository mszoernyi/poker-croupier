require "sinatra"
require "mustache"

require "twitter"
require "yaml"

set :public_folder, File.dirname(__FILE__)

get "/" do
  List.new.render
end

get "/game" do
  Game.new(request[:log]).render
end

BASE_DIR = File.dirname(__FILE__)+"/../"
LOG_DIR = File.dirname(__FILE__)+"/../log/"
PREVIOUS_EVENTS_DIR = File.dirname(__FILE__)+"/../previous_events/"

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__)
end

class List < MustacheBase
  def log_files
    Dir.glob("#{LOG_DIR}*.json").sort.map { |file| { :file => File.basename(file, ".json") } }
  end

  def previous_events
    Dir.glob("#{PREVIOUS_EVENTS_DIR}*/*.json").sort.map { |file| { :file => File.dirname(file).split('/')[-1] + "/" + File.basename(file, ".json") } }
  end
end  

class Game < MustacheBase
  def initialize(log)
    @log_file = log
  end

  def game_json
    File.read("#{BASE_DIR}#{@log_file}.json")
  end

  def tweets
    config_file = File.dirname(__FILE__) + '/twitter_api.yml'
    return "[]" unless FileTest.exist? config_file

    twitter_config = YAML.load(File.open(config_file).read)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key    = twitter_config['key']
      config.consumer_secret = twitter_config['secret']
    end

    JSON.generate(client.search(twitter_config['search'], rpp: 10, result_type:'recent').take(10).map do |tweet|
      {
          profile_image: tweet.user.profile_image_url.to_s,
          username: tweet.user.username,
          text: tweet.text
      }
    end)
  end
end
