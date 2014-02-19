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

  def log_state(game_state, additional_data = {})
    state = game_state.merge additional_data

    @history << JSON.generate(state)
  end
end
