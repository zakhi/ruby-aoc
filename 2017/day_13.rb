Layer = Struct.new(:depth, :range) do
  def caught?(delay = 0)
    (depth + delay) % (range * 2 - 2) == 0
  end

  def severity
    depth * range
  end
end

layers = File.readlines("input/day_13").map do |line|
  depth, range = /(\d+): (\d+)/.match(line)[1..2].map(&:to_i)
  Layer.new(depth, range)
end

severity = layers.select(&:caught?).sum(&:severity)
puts "Part 1: #{severity}"

minimum_delay = 1.step.find do |delay|
  layers.none? { |layer| layer.caught?(delay) }
end

puts "Part 2: #{minimum_delay}"
