require "sinatra"
require "poker_ranking"
require "json"

set :port, 2048

post "/" do
  cards = JSON.parse(request[:cards])
  JSON.generate PokerRanking::Hand.new(cards).data
end