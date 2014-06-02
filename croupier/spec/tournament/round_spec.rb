require_relative '../spec_helper.rb'

describe Croupier::Tournament::Round do

  let(:player1) { fake_player('player1') }
  let(:player2) { fake_player('player2') }

  before :each do
    allow(player1).to receive(:version).and_return('version1')
    allow(player2).to receive(:version).and_return('version2')

    Croupier::log_file = 'some/log/file'
  end

  it "should add the latest log files" do
    subject.update_with([player1, player2])

    expect(subject.data['game_json']).to eq('some/log/file.json')
    expect(subject.data['game_log']).to eq('some/log/file.log')
  end

  it "should add each players with their places and points" do
    subject.update_with [player1, player2]

    expect(subject.data['ranking']).to eq({ 'player1'=>{'points'=>5, 'active' => false, 'place'=>1, 'version'=>'version1'}, 'player2'=>{'points'=>3, 'active' => false, 'place'=>2, 'version'=>'version2'}})
  end

  it "should add points to previous points" do
    subject.data = { 'ranking' => { 'player1'=>{'points'=>5, 'place'=>1, 'version'=>'version1'}, 'player2'=>{'points'=>3, 'place'=>2, 'version'=>'version2'}} }

    subject.update_with [player1, player2]

    expect(subject.data['ranking']).to eq({ 'player1'=>{'points'=>10, 'place'=>1, 'version'=>'version1'}, 'player2'=>{'points'=>6, 'place'=>2, 'version'=>'version2'}})
  end
end