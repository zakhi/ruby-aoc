class Array
  alias :x :first
  alias :z :last

  def y
    self[1]
  end
end

class Moon
  attr_reader :position

  def initialize(position)
    @initial_position = @position = position
    @velocity = [0, 0, 0]
  end

  def energy
    potential = @position.map(&:abs).sum
    kinetic = @velocity.map(&:abs).sum
    potential * kinetic
  end

  def at_initial_position?(axis)
    @position[axis] == @initial_position[axis] && @velocity[axis] == 0
  end

  def gravitate_towards(other)
    offsets = @position.zip(other.position).map do |mine, its|
      case
      when mine > its then -1
      when mine < its then 1
      else 0
      end
    end

    @velocity = @velocity.zip(offsets).map(&:sum)
  end

  def move
    @position = @position.zip(@velocity).map(&:sum)
  end
end

def move(moons)
  moons.combination(2) do |first, second|
    first.gravitate_towards(second)
    second.gravitate_towards(first)
  end

  moons.each { |moon| moon.move }
end

initial_positions = File.readlines("input/day_12").map do |line|
  /<x=(-?\d+), y=(-?\d+), z=(-?\d+)>/.match(line)[1..3].map(&:to_i)
end

moons = initial_positions.map { |position| Moon.new(position) }
1000.times { move(moons) }

total_energy = moons.sum(&:energy)
puts "Part 1 #{total_energy}"

moons = initial_positions.map { |position| Moon.new(position) }
steps = [nil, nil, nil]

1.step do |step|
  move(moons)

  steps.size.times do |axis|
    steps[axis] ||= step if moons.all? { |moon| moon.at_initial_position?(axis) }
  end

  break if steps.none?(&:nil?)
end

total_steps = steps.reduce(&:lcm)
puts "Part 2: #{total_steps}"
