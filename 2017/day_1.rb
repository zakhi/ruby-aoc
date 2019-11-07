digits = File.read("input/day_1").chomp.each_char.map(&:to_i)

first_part_solution = digits.each_cons(2).select { |a, b| a == b }.map(&:first).sum
first_part_solution += digits.last if digits.last == digits.first

puts "Part 1: #{first_part_solution}"

matching_digits = digits.each_with_index.select do |digit, index|
  digit == digits[(index + digits.size / 2) % digits.size]
end

second_part_solution = matching_digits.map(&:first).sum
puts "Part 2: #{second_part_solution}"
