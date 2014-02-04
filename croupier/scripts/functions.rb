
Dir.chdir File.dirname(__FILE__)

require_relative '../croupier'

def sit_and_go(log_file, &block)
  Croupier::log_file = log_file
  handler = Croupier::Handler.new

  handler.instance_eval &block

  handler.start_sit_and_go
end

def start_players(number_of_players)
  player_names = %w(Albert Bob Chuck Daniel Emily Franky George Huge Ivan Joe Kevin Leo Mike Nikki Oliver Peter Q Robert Steve Tom Ulric Victor Walt Xavier Yvette Zara)

  players = []

  player_names[0..number_of_players-1].each_with_index do |player_name, index|
    players[index] = fork do
      exec "bundle exec ruby ../../player/rb/player_service.rb #{9200+index} '#{player_name}'"
    end
  end

  players.each do |player|
    Process.detach(player)
  end
  players
end

def run_timestamp
  Time.now.strftime("%Y_%m_%d_%H_%M_%S")
end