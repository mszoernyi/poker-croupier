require 'json'

class Croupier::LogHandler::Json

  def initialize(file)
    @history = []
    @file = file
  end

  def flush
    File.open(@file, 'w') do |file|
      file.puts "[" + @history.join(",\n") + "]"
    end
  end

  def log_state(data)
    Croupier::logger.info data[:message] unless data[:message].nil?
    @history << JSON.generate(data)
  end
end
