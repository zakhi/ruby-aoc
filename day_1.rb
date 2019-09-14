require "set"

changes = File.readlines("input/day_1").map { |line| line.chomp.to_i }

puts "Part 1: #{changes.sum}"

met_frequencies = Set[]
current_frequency = 0

repeated_frequency = changes.cycle.each do |change|
  current_frequency += change
  break current_frequency if met_frequencies.include?(current_frequency)
  met_frequencies << current_frequency
end

puts "Part 2: #{repeated_frequency}"
