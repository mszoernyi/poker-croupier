$:.push('lib/api')

require_relative 'functions'

number_of_players = (ARGV.length > 0) ? ARGV[0].to_i : 2

sit_and_go "../../log/integration_test_java" do
  for index in 0..number_of_players - 1
    register_thrift_player("localhost:#{9200+index}")
  end
end

