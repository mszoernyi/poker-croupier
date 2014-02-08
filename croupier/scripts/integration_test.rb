$:.push('lib/api')

require_relative 'functions'

number_of_players = (ARGV.length > 0) ? ARGV[0].to_i : 3

players = start_players(number_of_players)

sleep(1)

sit_and_go "../../log/integration_test" do
  players.each_index do |index|
    register_thrift_player("localhost:#{9200+index}")
  end
  register_player "Robert Rest", ""
end

