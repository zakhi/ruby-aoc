Disc = Struct.new(:id, :positions, :initial)
Factor = Struct.new(:divisor, :remainder)

discs = File.readlines("input/day_15").map do |line|
  id, positions, initial = /Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)./.match(line)[1..3].map(&:to_i)
  Disc.new(id, positions, initial)
end

factors = discs.map { |disc| Factor.new(disc.positions, -(disc.initial + disc.id) % disc.positions) }

common_factor = proc do |factor1, factor2|
  min, max = [factor1, factor2].minmax_by(&:divisor)
  common = max.remainder.step(by: max.divisor).find { |n| n % min.divisor == min.remainder }
  Factor.new(factor1.divisor * factor2.divisor, common)
end

press_time = factors.reduce(&common_factor).remainder
puts "Part 1: #{press_time}"

new_factors = factors + [Factor.new(11, -(discs.last.id + 1) % 11)]
new_press_time = new_factors.reduce(&common_factor).remainder
puts "Part 2: #{new_press_time}"
