require "sinatra"
require "mustache"

set :public_folder, File.dirname(__FILE__)

get "/" do
  List.new.render
end

get "/game" do
  Game.new(request[:log]).render
end


$LOG_DIR = File.dirname(__FILE__)+"/../log/"

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__)
end

class List < MustacheBase
  def log_files
    Dir.glob("#{$LOG_DIR}*.json").map { |file| { :file => File.basename(file, ".json") } }
  end
end  

class Game < MustacheBase
  def initialize(log)
    @log_file = log
  end

  def game_json
    File.read("#{$LOG_DIR}#{@log_file}.json")
  end
end
