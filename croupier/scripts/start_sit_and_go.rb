require_relative 'functions'

sit_and_go "../../log/game_#{run_timestamp}" do
  # PHP client
  register_rest_player "PHilip Pots", "http://localhost:8000/player_service.php"

  # Ruby client
  register_rest_player "Rudy Ruby", "http://localhost:8090/"

  # Java client
  register_rest_player "Jim Java", "http://localhost:8080/"

  # JavaScript client
  register_rest_player "Jim Java", "http://localhost:1337/"

  # Python client
  register_rest_player "Peter Python", "http://localhost:9000/"


end
