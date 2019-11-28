require "set"

class Grid
  attr_reader :total_infected

  def initialize(infected, position, with_resistance: false)
    @states = Hash.new(:clean)
    infected.each { |p| @states[p] = :infected }

    @position = position
    @with_resistance = with_resistance

    @directions = [:up, :right, :down, :left]
    @total_infected = 0
  end

  def burst
    self.state = case state
    when :clean
      turn_left
      @with_resistance ? :weakened : :infected
    when :weakened
      :infected
    when :infected
      turn_right
      @with_resistance ? :flagged : :clean
    when :flagged
      turn_backwards
      :clean
    end

    @total_infected += 1 if state == :infected
    advance
  end

  def turn_right
    @directions << @directions.shift
  end

  def turn_left
    @directions.unshift(@directions.pop)
  end

  def turn_backwards
    2.times { turn_left }
  end

  def advance
    offset = case current_direction
    when :up then [0, -1]
    when :down then [0, 1]
    when :right then [1, 0]
    when :left then [-1, 0]
    end

    @position = @position.zip(offset).map(&:sum)
  end

  def current_direction
    @directions.first
  end

  def state
    @states[@position]
  end

  def state=(new_state)
    if new_state == :clean
      @states.delete(@position)
    else
      @states[@position] = new_state
    end
  end
end

infected = File.readlines("input/day_22").each_with_object(Set[]).with_index do |(line, infected), y|
  line.chomp.each_char.with_index do |char, x|
    infected << [x, y] if char == "#"
  end
end

grid = Grid.new(infected, [12, 12])
10_000.times { grid.burst }

puts "Part 1: #{grid.total_infected}"

grid_with_resistance = Grid.new(infected, [12, 12], with_resistance: true)
10_000_000.times { grid_with_resistance.burst }

puts "Part 2: #{grid_with_resistance.total_infected}"

