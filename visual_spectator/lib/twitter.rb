class VisualSpectator::Twitter

  def tweets
    begin
      JSON.generate(search_result.take(10).map do |tweet|
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

  private

  def search_result
    client.search(twitter_config['search'], rpp: 10, result_type: 'recent')
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key = twitter_config['key']
      config.consumer_secret = twitter_config['secret']
    end
  end

  def twitter_config
    if @twitter_config.nil?
      raise FileNotFoundException.new unless FileTest.exist? config_file
      @twitter_config = YAML.load(File.open(config_file).read)
    end
    @twitter_config
  end

  def config_file
    File.dirname(__FILE__) + '/../twitter_api.yml'
  end
end