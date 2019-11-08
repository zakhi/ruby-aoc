passphrases = File.readlines("input/day_4").map do |line|
  line.scan(/\w+/)
end

valid = passphrases.count { |words| words.uniq.size == words.size }
puts "Part 1: #{valid}"

new_valid = passphrases.count { |words| words.map { |word| word.chars.sort.join }.uniq.size == words.size }
puts "Part 2: #{new_valid}"
