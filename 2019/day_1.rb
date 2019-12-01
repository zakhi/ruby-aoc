masses = File.readlines("input/day_1").map(&:to_i)

fuel = masses.map { |mass| mass / 3 - 2 }.sum
puts "Part 1: #{fuel}"

def fuel_required(mass)
  fuel = mass / 3 - 2
  fuel <= 0 ? 0 : fuel + fuel_required(fuel)
end

total_fuel = masses.map { |mass| fuel_required(mass) }.sum
puts "Part 2: #{total_fuel}"
