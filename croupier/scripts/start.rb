require_relative 'functions'

sit_and_go "../../log/game_#{run_timestamp}" do
  register_rest_player "PHilip Pots", "http://localhost:8080/player_service.php"
end
