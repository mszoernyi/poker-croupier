
class Croupier::Tournament::Controller
  def initialize
    @players = []
  end

  def register_rest_player(name, strategy)
    @players << { name: name, strategy: strategy }
  end

  def start_tournament(options)
    iterations_left = options[:max_iterations] || -1
    while iterations_left != 0
      sit_and_go_controller = Croupier::SitAndGo::Controller.new
      @players.each do |player|
        sit_and_go_controller.register_rest_player player[:name], player[:strategy]
      end
      sit_and_go_controller.start_sit_and_go

      iterations_left -= 1
    end
  end
end