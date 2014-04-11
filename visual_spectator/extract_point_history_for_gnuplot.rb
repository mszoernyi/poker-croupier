require 'json'

File.readlines(ARGV[0]).each_with_index do |line, index|
  data = JSON.parse(line)
  result = [index]
  data['ranking'].each do |name, player|
    result << player['points'] - 8.0*(index+1)/data['ranking'].length
  end
  puts result.join(', ')
end