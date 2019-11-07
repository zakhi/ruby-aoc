rows = File.readlines("input/day_2").map do |line|
  line.scan(/\d+/).map(&:to_i)
end

differences = rows.map do |row|
  min, max = row.minmax
  max - min
end

puts "Part 1: #{differences.sum}"

division_results = rows.map do |row|
  dividend, divisor = row.permutation(2).find { |a, b| a % b == 0 }
  dividend / divisor
end

puts "Part 2: #{division_results.sum}"
