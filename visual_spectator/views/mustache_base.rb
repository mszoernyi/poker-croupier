require 'mustache'

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__) + "/../template"

  def strip_path_and_extension(file)
    File.dirname(file).split('/')[-1] + "/" + File.basename(file, ".*")
  end
end