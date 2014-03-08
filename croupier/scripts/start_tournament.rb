require_relative 'functions'

CROUPIER_ROOT = "../.."
PLAYERS_ROOT = "../../.."

tournament do
  tournament_logfile "#{CROUPIER_ROOT}/log/tournament_#{run_date}"
  sit_and_go_logfile "#{CROUPIER_ROOT}/log/game_#{run_timestamp}"

  register_git_player "Cecil P. Plush", "#{PLAYERS_ROOT}/poker-player-cpp"
  register_git_player "Jim Java", "#{PLAYERS_ROOT}/poker-player-java"
  register_git_player "Javier Scrivo", "#{PLAYERS_ROOT}/poker-player-js"
  register_git_player "PHilip Pots", "#{PLAYERS_ROOT}/poker-player-php"
  register_git_player "Peter Python", "#{PLAYERS_ROOT}/poker-player-python"
  register_git_player "Rudy Ruby", "#{PLAYERS_ROOT}/poker-player-ruby"
end