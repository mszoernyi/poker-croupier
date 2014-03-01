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

    sit_and_go_controller = Croupier::SitAndGo::Controller.new
    @players.each do |player|
      config = YAML.load_file("#{player[:directory]}/config.yml")
      Process.spawn("bash #{player[:directory]}/start.sh")
      sit_and_go_controller.register_rest_player player[:name], config["url"]
    end

    sleep(2)
    sit_and_go_controller.start_sit_and_go

    @players.each do |player|
      Process.spawn("bash #{player[:directory]}/stop.sh")
    end

  end
end