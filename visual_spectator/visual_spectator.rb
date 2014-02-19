require "sinatra"
require "mustache"

set :public_folder, File.dirname(__FILE__)

get "/" do
  List.new.render
end

get "/game" do
  Game.new(request[:log]).render
end

BASE_DIR = File.dirname(__FILE__)+"/../"
LOG_DIR = File.dirname(__FILE__)+"/../log/"
PREVIOUS_EVENTS_DIR = File.dirname(__FILE__)+"/../previous_events/"

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__)
end

class List < MustacheBase
  def log_files
    Dir.glob("#{LOG_DIR}*.json").sort.map { |file| { :file => File.basename(file, ".json") } }
  end

  def previous_events
    Dir.glob("#{PREVIOUS_EVENTS_DIR}*/*.json").sort.map { |file| { :file => File.dirname(file).split('/')[-1] + "/" + File.basename(file, ".json") } }
  end
end  

class Game < MustacheBase
  def initialize(log)
    @log_file = log
  end

  def game_json
    File.read("#{BASE_DIR}#{@log_file}.json")
  end
end
