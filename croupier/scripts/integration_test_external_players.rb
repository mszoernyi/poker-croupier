$:.push('lib/api')

require_relative 'functions'

number_of_players = (ARGV.length > 0) ? ARGV[0].to_i : 2

sit_and_go "../../log/integration_test_java" do
  (0...number_of_players).each do |index|
    register_thrift_player("localhost:#{9200+index}")
  end
end

