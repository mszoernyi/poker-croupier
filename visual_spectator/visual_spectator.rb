$:.push(File.join(File.dirname(__FILE__), 'lib/api'))
$:.push(File.join(File.dirname(__FILE__)))

module VisualSpectator
  autoload :Game, 'lib/game'
  autoload :Player, 'lib/player'
  autoload :Tournament, 'lib/tournament'
  autoload :Twitter, 'lib/twitter'
end