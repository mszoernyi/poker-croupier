$:.push('lib/api')

require_relative 'functions'

number_of_players = (ARGV.length > 0) ? ARGV[0].to_i : 3

sit_and_go "../../log/integration_test" do
  (0...number_of_players).each do |index|
    register_in_process_player PLAYER_NAMES[index], Croupier::RandomPlayer
  end
end

