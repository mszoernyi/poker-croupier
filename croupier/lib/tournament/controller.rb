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
    player_services = []

    sit_and_go_controller = Croupier::SitAndGo::Controller.new
    @players.each do |player|
      config = YAML.load_file("#{player[:directory]}/config.yml")
      player_services << fork do
        exec("bash #{player[:directory]}/start.sh")
        player_services << $?.pid
      end

      sit_and_go_controller.register_rest_player player[:name], config["url"]
    end
    sit_and_go_controller.start_sit_and_go

    p player_services

    player_services.each do |player_service|
      Process.kill 9, player_service
      Process.wait player_service
    end
  end
end