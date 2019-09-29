require "set"

cities = Set[]
distances = {}

File.readlines("input/day_9").each do |line|
  source, destination, distance = /(\w+) to (\w+) = (\d+)/.match(line)[1..3]
  cities << source << destination
  distances[Set[source, destination]] = distance.to_i
end

route_distances = cities.to_a.permutation(cities.size).map do |route|
  route.each_cons(2).sum { |source, destination| distances[Set[source, destination]] }
end

puts "Part 1: #{route_distances.min}"
puts "Part 2: #{route_distances.max}"
