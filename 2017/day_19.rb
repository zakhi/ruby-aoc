class Array
  alias :x :first
  alias :y :last
end

class Routine
    OFFSETS = {
      down: [0, 1],
      left: [-1, 0],
      up: [0, -1],
      right: [1, 0]
    }

  attr_reader :letters, :steps

  def initialize(diagram)
    @diagram = diagram
    @direction = :down
    @letters = []
    @steps = 0
  end

  def travel
    position = @diagram.each_key.find { |pos| pos.y == 0 }

    while @diagram.include?(position)
      @steps += 1
      char = @diagram[position]
      @letters << char if char =~ /\w/
      position = advance(position, char)
    end
  end

  def advance(position, char)
    if char == "+"
      @direction = turn_directions.find { |direction| @diagram.include?(next_position(position, direction)) }
    end

    next_position(position)
  end

  def next_position(position, direction = @direction)
    position.zip(OFFSETS[direction]).map(&:sum)
  end

  def turn_directions
    case @direction
    when :up, :down then [:left, :right]
    else [:up, :down]
    end
  end
end

diagram = {}

File.readlines("input/day_19").each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    diagram[[x, y]] = char unless char == " "
  end
end

routine = Routine.new(diagram)
routine.travel

puts "Part 1: #{routine.letters.join}"
puts "Part 2: #{routine.steps}"