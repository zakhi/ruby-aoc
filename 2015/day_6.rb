require "set"

class Instruction
  include Enumerable

  attr_reader :operation

  def initialize(operation, xs, ys)
    @operation, @xs, @ys = operation, xs, ys
  end

  def each
    @ys.each do |y|
      @xs.each do |x|
        yield [x, y]
      end
    end
  end
end

instructions = File.readlines("input/day_6").map do |line|
  match = /(toggle|turn on|turn off) (\d+),(\d+) through (\d+),(\d+)/.match(line)
  operation = match[1].split[-1].to_sym
  xs = Range.new(*match.values_at(2, 4).map(&:to_i))
  ys = Range.new(*match.values_at(3, 5).map(&:to_i))
  Instruction.new(operation, xs, ys)
end

lights = Array.new(1000) { Array.new(1000, false) }

instructions.each do |instruction|
  instruction.each do |x, y|
    lights[x][y] = case instruction.operation
    when :on then true
    when :off then false
    when :toggle then !lights[x][y]
    end
  end
end

total_lights = lights.sum { |xs| xs.count(&:itself) }
puts "Part 1: #{total_lights}"

brightnesses = Array.new(1000) { Array.new(1000, 0) }

instructions.each do |instruction|
  instruction.each do |x, y|
    brightnesses[x][y] = case instruction.operation
    when :on then brightnesses[x][y] + 1
    when :off then [0, brightnesses[x][y] - 1].max
    when :toggle then brightnesses[x][y] + 2
    end
  end
end

total_brightness = brightnesses.sum { |xs| xs.sum }
puts "Part 1: #{total_brightness}"
