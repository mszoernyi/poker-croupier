require_relative 'functions'

CROUPIER_ROOT = "../.."
PLAYERS_ROOT = "../../.."

tournament do
  tournament_logfile "#{CROUPIER_ROOT}/log/tournament_#{run_date}"
  sit_and_go_logfile "#{CROUPIER_ROOT}/log/game_#{run_timestamp}"

  register_git_player "John Script", "#{PLAYERS_ROOT}/poker-player-js"
  register_git_player "Rudy Ruby", "#{PLAYERS_ROOT}/poker-player-ruby"
  register_git_player "PHilip Pots", "#{PLAYERS_ROOT}/poker-player-php"
  register_git_player "Jim Java", "#{PLAYERS_ROOT}/poker-player-java"
end