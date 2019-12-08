layers = File.read("input/day_8").chomp.chars.map(&:to_i).each_slice(150).to_a

minimal_layer = layers.min_by { |layer| layer.count(0) }
counts = minimal_layer.group_by(&:itself).transform_values(&:count)

puts "Part 1: #{counts[1] * counts[2]}"

message = layers.transpose.map do |codes|
  codes.find { |code| code != 2 }
end

puts "Part 2:"
message.each_slice(25) do |line|
  puts line.map { |char| char == 1 ? "#" : " " }.join
end
