present_dimensions = File.readlines("input/day_2").map do |line|
  /(\d+)x(\d+)x(\d+)/.match(line)[1..3].map(&:to_i)
end

def paper_needed(dimensions)
  sides = dimensions.combination(2).map { |a,b| a * b }
  2 * sides.sum + sides.min
end

total_paper_needed = present_dimensions.map { |d| paper_needed(d) }.sum
puts "Part 1: #{total_paper_needed}"

def ribbon_needed(dimensions)
  smallest_side = dimensions.combination(2).map(&:sum).min
  2 * smallest_side + dimensions.inject(&:*)
end

total_ribbon_required = present_dimensions.map { |d| ribbon_needed(d) }.sum
puts "Part 2: #{total_ribbon_required}"
