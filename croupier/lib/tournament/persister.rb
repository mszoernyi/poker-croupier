class Croupier::Tournament::Persister
  class << self
    def load_last_from(tournament_file)
      if File.exists?(tournament_file)
        lines = IO.readlines(tournament_file)
        Croupier::Tournament::Round.new JSON.parse(lines[-1]) if lines.length > 0
      else
        Croupier::Tournament::Round.new
      end
    end

    def append_to(tournament_file, tournament_round)
      File.open(tournament_file, 'a') do |file|
        file.puts JSON.generate tournament_round.data
      end
    end
  end

end