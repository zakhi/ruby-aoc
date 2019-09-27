require_relative("../helpers/enumerable")

box_ids = File.readlines("input/day_2").map(&:chomp)
twos, threes = 0, 0

box_ids.each do |id|
  letter_counts = id.each_char.tally
  twos += 1 if letter_counts.values.include?(2)
  threes += 1 if letter_counts.values.include?(3)
end

puts "Part 1: #{twos * threes}"

match = box_ids.combination(2).each do |first, second|
  same_chars = first.each_char.zip(second.each_char).select { |c1, c2| c1 == c2 }.map(&:first).join
  break same_chars if same_chars.length == first.length - 1
end

puts "Part 2: #{match}"
