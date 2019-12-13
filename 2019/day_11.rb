require_relative "intcode"

class Array
  alias :x :first
  alias :y :last

  def x=(value)
    self[0] = value
  end

  def y=(value)
    self[1] = value
  end
end

class PaintingRobot
  def initialize(program)
    @computer = IntCodeComputer.new(program)
    @computer.input = self
    @computer.output = self
    @panels = Hash.new(0)
    @directions = [[0, -1], [1, 0], [0, 1], [-1, 0]]
  end

  def paint(start: 0)
    @position = [0, 0]
    @panels[@position] = start

    @status = :painting
    @computer.run
  end

  def total_painted
    @panels.keys.count
  end

  def show
    positions = @panels.keys
    Range.new(*positions.map(&:y).minmax).each do |y|
      xs = Range.new(*positions.map(&:x).minmax).map do |x|
        @panels[[x, y]] == 1 ? "#" : " "
      end

      puts xs.join
    end
  end

  def <<(number)
    case @status
    when :painting
      @panels[@position] = number
      @status = :moving
    when :moving
      number == 0 ? turn_left : turn_right
      move
      @status = :painting
    end
  end

  def shift
    @panels[@position]
  end

  def turn_left
    @directions.rotate!(-1)
  end

  def turn_right
    @directions.rotate!
  end

  def move
    @position = @position.zip(@directions.first).map(&:sum)
  end
end

source = File.read("input/day_11").chomp.split(",").map(&:to_i)
robot = PaintingRobot.new(source)
robot.paint

puts "Part 1: #{robot.total_painted}"

correct_robot = PaintingRobot.new(source)
correct_robot.paint(start: 1)

puts "Part 2:"
correct_robot.show
