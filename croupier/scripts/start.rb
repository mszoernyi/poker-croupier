require_relative 'functions'

sit_and_go "../../log/game_#{run_timestamp}" do
  # PHP client
  register_rest_player "PHilip Pots", "http://localhost:8080/player_service.php"

  # Ruby client
  register_rest_player "Rudy Ruby", "http://localhost:4567/"
end
