require 'sidekiq'
require_relative '../croupier'

class RunGameWorker
  include Sidekiq::Worker

  def perform(players, response_url)
    Croupier::log_file = 'log/tmp'
    controller = Croupier::SitAndGo::Controller.new
    controller.logger = Croupier::LogHandler::Json.new("#{Croupier::log_file}.json")

    JSON.parse(players).each do |player|
      controller.register_rest_player player['name'], player['url']
    end

    players_ranking = controller.start_sit_and_go

    players_ranking_json = JSON.generate(players_ranking.map do |player|
      {
          name: player.name,
          version: player.version
      }
    end)

    result = {ranking: players_ranking_json, log: JSON.generate(controller.logger.logs)}

    Croupier::HttpRequestLight.post response_url, result do |error, response|
      if error
        return false
      end

      puts response
    end

    true
  end
end
