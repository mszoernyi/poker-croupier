require_relative 'functions'

sit_and_go "../../log/game_#{run_timestamp}" do

  # C++ client
  register_rest_player "Cecil P. Plush", "http://localhost:9300/"

  # Java client
  register_rest_player "Jim Java", "http://localhost:8080/"

  # JavaScript client
  register_rest_player "Javier Scrivo", "http://localhost:1337/"

  # PHP client
  register_rest_player "PHilip Pots", "http://localhost:8000/player_service.php"

  # Python client
  register_rest_player "Peter Python", "http://localhost:9000/"

  # Ruby client
  register_rest_player "Rudy Ruby", "http://localhost:8090/"
end
