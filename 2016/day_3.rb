def is_triangle?(sides)
  largest_side = sides.max
  largest_side < sides.sum - largest_side
end

triplets = File.readlines("input/day_3").map do |line|
  /(\d+)\s+(\d+)\s+(\d+)/.match(line)[1..3].map(&:to_i)
end

puts "Part 1: #{triplets.count { |t| is_triangle?(t) }}"

column_triplets = triplets.transpose.flat_map { |column| column.each_slice(3).to_a }
puts "Part 2:#{column_triplets.count { |t| is_triangle?(t) }}"
