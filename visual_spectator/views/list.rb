require_relative 'mustache_base'

class List < MustacheBase
  def log_files
    Dir.glob("#{LOG_DIR}tournament_*.json").sort.map { |file| {:file => strip_path_and_extension(file)} }
  end
end
