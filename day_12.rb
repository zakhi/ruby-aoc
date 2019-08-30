require "set"
require_relative "helpers/enumerable"

initial_state, rules = File.open("input/day_12") do |file|
  initial_state = /[#.]+/.match(file.gets).to_s
    .each_char.with_index.map { |c, i| c == "#" ? i : nil }.compact

  file.gets # empty line

  rules = file.readlines
    .map { |line| /([#.]{5}) => #/.match(line) }.compact
    .map { |match| match[1].each_char.with_index.map { |c, i| c == "#" ? i - 2 : nil }.compact.to_a }

  [initial_state.to_set, rules.to_set]
end

def transform(state, rules)
  min = state.min - 2
  max = state.max + 2
  
  new_state = (min..max).select do |index|
    area = (index - 2)..(index + 2)
    plants_in_area = area.select { |i| state.include? i }
    rules.include? plants_in_area.map { |i| i - index }
  end

  new_state.reject(&:nil?).to_set
end

def grow(state, rules, generations) 
  generations.times.inject(state) do |current_state, *|
    transform(current_state, rules)
  end
end

puts "Part 1: #{grow(initial_state, rules, 20).sum}"

iterations = 50000000000

repeating_state, generation = (1..iterations).inject(initial_state) do |current_state, gen|
  new_state = transform(current_state, rules)
  break [new_state, gen] if new_state.map { |i| i - 1 } == current_state.to_a
  new_state
end

end_state = repeating_state.map { |i| i + iterations - generation }
puts "Part 2: #{end_state.sum}"
