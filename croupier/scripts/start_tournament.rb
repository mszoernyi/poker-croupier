require_relative 'functions'

CROUPIER_ROOT = "../.."
PLAYERS_ROOT = "../../.."

tournament do
  tournament_logfile "#{CROUPIER_ROOT}/log/tournament_#{run_date}"
  sit_and_go_logfile "#{CROUPIER_ROOT}/log/game_#{run_timestamp}"

  register_git_player "Cecil P. Plush", "#{PLAYERS_ROOT}/poker-player-cpp" # 9300
  register_git_player "Groovy Gamer", "#{PLAYERS_ROOT}/poker-player-groovy" # 8180
  register_git_player "His Pure Holiness", "#{PLAYERS_ROOT}/poker-player-haskell" # 1900
  register_git_player "Jim Java", "#{PLAYERS_ROOT}/poker-player-java" # 8080
  register_git_player "Javier Scrivo", "#{PLAYERS_ROOT}/poker-player-js" # 1337
  register_git_player "PHilip Pots", "#{PLAYERS_ROOT}/poker-player-php" # 8000
  register_git_player "Peter Python", "#{PLAYERS_ROOT}/poker-player-python" # 9000
  register_git_player "Rudy Ruby", "#{PLAYERS_ROOT}/poker-player-ruby" # 8090
end
