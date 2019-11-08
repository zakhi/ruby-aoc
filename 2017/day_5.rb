jumps = File.readlines("input/day_5").map do |line|
  /-?\d+/.match(line)[0].to_i
end

def run(jumps, decrement_if_at_least: nil)
  steps = jumps.clone
  current = 0

  0.step.each do |count|
    break count unless current < steps.size

    value = steps[current]
    steps[current] += decrement_if_at_least&.<=(value) ? -1 : 1
    current += value
  end
end

puts "Part 1: #{run(jumps)}"
puts "Part 2: #{run(jumps, decrement_if_at_least: 3)}"
