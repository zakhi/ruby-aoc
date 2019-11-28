require "set"

components = File.readlines("input/day_24").map do |line|
  %r{(\d+)/(\d+)}.match(line)[1..2].map(&:to_i)
end

def strongest_bridge(pins, components)
  bridges = components.select { |c| c.include?(pins) }.map do |component|
    other_pins = component.uniq.size == 1 ? component.first : component.find { |p| p != pins }
    component.sum + strongest_bridge(other_pins, components - [component])
  end

  bridges.max || 0
end

puts "Part 1: #{strongest_bridge(0, components.to_set)}"

def longest_bridges(pins, components)
  bridges = components.select { |c| c.include?(pins) }.flat_map do |component|
    other_pins = component.uniq.size == 1 ? component.first : component.find { |p| p != pins }
    inner_bridges = longest_bridges(other_pins, components - [component])
    inner_bridges.empty? ? [[component]] : inner_bridges.map { |bridge| [component] + bridge }
  end

  return [] if bridges.empty?

  max_size = bridges.map(&:size).max
  bridges.select { |b| b.size == max_size }
end

longest = longest_bridges(0, components.to_set).map { |bridge| bridge.sum(&:sum) }.max
puts "Part 2: #{longest}"
