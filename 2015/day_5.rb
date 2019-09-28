strings = File.readlines("input/day_5").map(&:chomp)

nice_strings = strings.count do |string|
  three_vowels = string.each_char.count { |c| %w(a e i o u).include?(c) } >= 3
  twice_in_row = string.each_char.each_cons(2).any? { |c1, c2| c1 == c2 }
  no_exclusions = %w(ab cd pq xy).none? { |s| string.include?(s) }

  three_vowels && twice_in_row && no_exclusions
end

puts "Part 1: #{nice_strings}"

nicer_strings = strings.count do |string|
  pair_repeating = string.each_char.each_cons(2).with_index.any? { |pair, index| string[index + 2..].include?(pair.join) }
  letter_repeating = string.each_char.each_cons(3).any? { |c1, *, c3| c1 == c3 }

  pair_repeating && letter_repeating
end

puts "Part 2: #{nicer_strings}"
