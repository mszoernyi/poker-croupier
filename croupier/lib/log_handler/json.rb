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
    @state = game_state.merge additional_data
    save_step

    refresh_player_index(game_state)
  end

  private

  def refresh_player_index(game_state)
    @player_index = {}
    game_state[:players].each_with_index do |player, index|
      @player_index[player[:name]] = index
    end
  end

  def json_player(competitor)
    @state[:players][@player_index[competitor.name]]
  end

  def save_step
    @history << JSON.generate(@state)
  end
end
