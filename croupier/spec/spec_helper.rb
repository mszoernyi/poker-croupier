$:.push(File.join(File.dirname(__FILE__), '../../common/lib'))
$:.push(File.join(File.dirname(__FILE__)))

require_relative '../croupier'

module SpecHelper
  autoload :DummyClass, 'spec_helper/dummy_class'
  autoload :FakeStrategy, 'spec_helper/fake_strategy'
  autoload :FakeSpectator, 'spec_helper/fake_spectator'
  autoload :MakeTournamentState, 'spec_helper/make_tournament_state'
end

def fake_player(name = 'FakePlayer')
  Croupier::Player.new SpecHelper::FakeStrategy.new(name)
end
