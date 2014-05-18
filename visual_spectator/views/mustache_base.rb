require 'mustache'

class MustacheBase < Mustache
  self.template_path = File.dirname(__FILE__) + "/../template"
end