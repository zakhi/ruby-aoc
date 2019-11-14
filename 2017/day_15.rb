class Generator
  include Enumerable

  def initialize(initial_value, multiplier)
    @initial_value, @multiplier = initial_value, multiplier
  end

  def each
    value = @initial_value

    loop do
      value = (value * @multiplier) % 2147483647
      yield value & 0xffff
    end
  end
end

initializers = File.readlines("input/day_15").map do |line|
  /(\d+)/.match(line)[1].to_i
end

generator_a, generator_b = initializers.zip([16807, 48271]).map do |initial_value, multiplier|
  Generator.new(initial_value, multiplier)
end

matches = generator_a.lazy.zip(generator_b).take(40_000_000).count { |a, b| a == b }
puts "Part 1: #{matches}"

filtered_a = generator_a.lazy.select { |value| value % 4 == 0 }
filtered_b = generator_b.lazy.select { |value| value % 8 == 0 }

filtered_matches = filtered_a.zip(filtered_b).take(5_000_000).count { |a, b| a == b }
puts "Part 2: #{filtered_matches}"
