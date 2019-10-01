containers = File.readlines("input/day_17").map { |line| line.chomp.to_i }

matching_combinations = containers.size.times.flat_map do |container_count|
  containers.combination(container_count).select { |selected_containers| selected_containers.sum == 150 }
end

puts "Part 1: #{matching_combinations.size}"

minimum_number_of_containers = matching_combinations.map(&:size).min
number_of_minimum_matches = matching_combinations.count { |match| match.size == minimum_number_of_containers }
puts "Part 2: #{number_of_minimum_matches}"
