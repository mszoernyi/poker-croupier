require 'yaml'

class Croupier::Tournament::Controller
  def initialize
    @players = []
    @processes = []
  end

  def sit_and_go_logfile(log_file)
    Croupier::log_file = log_file
  end

  def tournament_logfile(log_file)
    @tournament_logfile = "#{log_file}.json"
  end

  def register_git_player(name, directory)
    @players << { name: name, directory: directory }
  end

  def start_tournament
    reset_players_to_git_master

    sit_and_go_controller = Croupier::SitAndGo::Controller.new

    start_players(sit_and_go_controller)

    wait_for_players_to_start(sit_and_go_controller)

    ranking = sit_and_go_controller.start_sit_and_go

    log_ranking_and_points(ranking)

    stop_players
    wait_for_all_processes_to_stop
  end


  private

  def log_ranking_and_points(ranking)
    tournament_round = {'ranking' => {}}

    if File.exists?(@tournament_logfile)
      lines = IO.readlines(@tournament_logfile)
      tournament_round = JSON.parse(lines[-1]) if lines.length > 0
    end

    tournament_round['game_json'] = Croupier::log_file + '.json'
    tournament_round['game_log'] = Croupier::log_file + '.log'

    ranking.each_with_index do |player, place|
      unless tournament_round['ranking'].has_key? player.name
        tournament_round['ranking'][player.name] = {'points' => 0}
      end

      tournament_round['ranking'][player.name]['place'] = place + 1
      tournament_round['ranking'][player.name]['version'] = player.version
    end
    tournament_round['ranking'][ranking[0].name]['points'] += 5
    tournament_round['ranking'][ranking[1].name]['points'] += 3

    File.open(@tournament_logfile, 'a') do |file|
      file.puts JSON.generate tournament_round
    end
  end

  def wait_for_players_to_start(sit_and_go_controller)
    max_iterations_left = 90
    until sit_and_go_controller.players_running? or max_iterations_left < 0
      Croupier::logger.info "Waiting for players to start"
      sleep(1)
      max_iterations_left -= 1
    end
    Croupier::logger.info "Players are running"
  end

  def reset_players_to_git_master
    @players.each do |player|
      Croupier::logger.info "Reseting #{player[:name]} to origin/master"
      `cd #{player[:directory]} && git fetch origin && git reset --hard origin/master && git clean -d -f`
    end
  end

  def wait_for_all_processes_to_stop
    @processes.each do |pid|
      Process.wait pid
    end
  end

  def stop_players
    @players.each do |player|
      @processes << Process.spawn("bash #{player[:directory]}/stop.sh")
    end
  end

  def start_players(sit_and_go_controller)
    @players.each do |player|
      config = YAML.load_file("#{player[:directory]}/config.yml")
      @processes << Process.spawn("bash #{player[:directory]}/start.sh")
      sit_and_go_controller.register_rest_player player[:name], config["url"]
    end
  end
end