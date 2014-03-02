require 'yaml'

class Croupier::Tournament::Controller
  def initialize
    @players = []
  end

  def set_sit_and_go_logfile(log_file)
    Croupier::log_file = log_file
  end

  def register_git_player(name, directory)
    @players << { name: name, directory: directory }
  end

  def start_tournament
    @players.each do |player|
      `cd #{player[:directory]} && git fetch origin && git reset --hard origin/master && git clean -d -f`
    end


    sit_and_go_controller = Croupier::SitAndGo::Controller.new

    start_players(sit_and_go_controller)

    sleep(10)
    sit_and_go_controller.start_sit_and_go

    stop_players

  end

  def stop_players
    @players.each do |player|
      Process.spawn("bash #{player[:directory]}/stop.sh")
    end
  end

  def start_players(sit_and_go_controller)
    @players.each do |player|
      config = YAML.load_file("#{player[:directory]}/config.yml")
      Process.spawn("bash #{player[:directory]}/start.sh")
      sit_and_go_controller.register_rest_player player[:name], config["url"]
    end
  end
end