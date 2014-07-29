require 'sidekiq'
require_relative '../croupier'

class RunGameWorker
  include Sidekiq::Worker

  def perform(players, response_url)
    controller = Croupier::SitAndGo::Controller.new
    controller.logger = Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")

    JSON.parse(players).each do |player|
      controller.register_rest_player player['name'], player['url']
    end

    ranking = controller.start_sit_and_go
  end
end
