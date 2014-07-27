require 'json'

class Croupier::LogHandler::Json

  attr_reader :history

  def initialize(file)
    @history = []
    @file = file
  end

  def flush
    File.open(@file, 'w') do |file|
      file.puts JSON.generate history
    end
  end

  def log_state(data)
    Croupier::logger.info data[:message] unless data[:message].nil?
    @history << JSON.parse(JSON.generate(data))
  end
end
