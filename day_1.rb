require "set"

changes = File.open("input/day_1") do |file|
  file.each_line.map(&:to_i)
end

puts "Part 1: #{changes.sum}"

met_frequencies = Set.new
current_frequency = 0

repeated_frequency = changes.cycle.each do |change|
  current_frequency += change
  break current_frequency if met_frequencies.include?(current_frequency)
  met_frequencies << current_frequency
end

puts "Part 2: #{repeated_frequency}"
