require "set"

class AnimatedLights
  def initialize(lights, size: 100, stuck_corners: false)
    @lights, @size, @stuck_corners = lights, size, stuck_corners
    @lights.merge(corners) if @stuck_corners
  end

  def count
    @lights.size
  end

  def run(steps)
    steps.times { animate }
  end

  def animate
    new_state = Set[]
    new_state.merge(corners) if @stuck_corners

    100.times do |y|
      100.times do |x|
        on_adjacents = adjacents(x, y).count { |light| @lights.include?(light) }
        should_be_on = @lights.include?([x, y]) ? on_adjacents.between?(2, 3) : on_adjacents == 3
        new_state << [x, y] if should_be_on
      end
    end
    @lights = new_state
  end

  def adjacents(x, y)
    offsets = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    offsets.map { |dx, dy| [x + dx, y + dy] }.select do |coordinates|
      coordinates.each { |c| c.between?(0, @size) }
    end
  end

  def corners
    edges = [0, @size - 1]
    edges.product(edges)
  end
end

initial_lights = Set[]

File.readlines("input/day_18").each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    initial_lights << [x, y] if char == "#"
  end
end

lights = AnimatedLights.new(initial_lights)
lights.run(100)
puts "Part 1: #{lights.count}"

bad_lights = AnimatedLights.new(initial_lights, stuck_corners: true)
bad_lights.run(100)
puts "Part 2: #{bad_lights.count}"
