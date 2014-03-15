class Croupier::Tournament::Round
  attr_accessor :data

  def initialize(data = {'ranking' => {}})
    @data = data
  end

  def update_with(ranking)
    set_log_files

    refresh_players(ranking)

    award_points(ranking)
  end

  private

  def refresh_players(ranking)
    ranking.each_with_index do |player, place|
      ensure_player(player)
      refresh_player_data(place, player)
    end
  end

  def award_points(ranking)
    data['ranking'][ranking[0].name]['points'] += 5
    data['ranking'][ranking[1].name]['points'] += 3
  end

  def refresh_player_data(place, player)
    data['ranking'][player.name]['place'] = place + 1
    data['ranking'][player.name]['version'] = player.version
  end

  def ensure_player(player)
    unless data['ranking'].has_key? player.name
      data['ranking'][player.name] = {'points' => 0}
    end
  end

  def set_log_files
    data['game_json'] = Croupier::log_file + '.json'
    data['game_log'] = Croupier::log_file + '.log'
  end
end