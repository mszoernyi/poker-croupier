require "sinatra"
require "poker_ranking"
require "json"

set :port, 2048

post "/" do
  cards = JSON.parse(request[:cards])
  if cards.length >= 5
    JSON.generate PokerRanking::Hand.new(cards).data
  else
    JSON.generate error: "Not enough cards"
  end
end