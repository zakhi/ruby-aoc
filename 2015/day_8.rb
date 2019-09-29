strings = File.readlines("input/day_8").map(&:chomp)

decoding_lengths = strings.map do |original|
  decoded = original.gsub(/\\\\|\\"|\\x[a-f\d]{2}/, "*")
  [original.length, decoded.length - 2]
end

decoding_diff = decoding_lengths.map { |orig, decoded| orig - decoded }.sum
puts "Part 1: #{decoding_diff}"

encoding_lengths = strings.map do |original|
  encoded = original.gsub(/["\\]/, "\\\1")
  [original.length, encoded.length + 2]
end

encoding_diff = encoding_lengths.map { |orig, encoded| encoded - orig }.sum
puts "Part 2: #{encoding_diff}"
