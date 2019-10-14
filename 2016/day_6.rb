require "../helpers/enumerable"

messages = File.readlines("input/day_6").map { |line| line.chomp.chars }

most_common_chars = messages.transpose.map do |chars|
  chars.tally.max_by(&:last).first
end

puts "Part 1: #{most_common_chars.join}"

least_common_chars = messages.transpose.map do |chars|
  chars.tally.min_by(&:last).first
end

puts "Part 2: #{least_common_chars.join}"
