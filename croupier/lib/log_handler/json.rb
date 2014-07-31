require 'json'

class Croupier::LogHandler::Json

  attr_reader :logs

  def initialize(file)
    @logs = []
    @file = file
  end

  def flush
    File.open(@file, 'w') do |file|
      file.puts JSON.generate logs
    end
  end

  def log_state(data)
    Croupier::logger.info data[:message] unless data[:message].nil?
    @logs << JSON.parse(JSON.generate(data))
  end
end
