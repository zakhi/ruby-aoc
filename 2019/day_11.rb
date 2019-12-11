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

class IntCodeComputer
  OPERATIONS = {
    1 => :add, 2 => :multiply, 3 => :read, 4 => :write,
    5 => :jump_unless_zero, 6 => :jump_if_zero, 7 => :less_than, 8 => :equals,
    9 => :adjust_relative_base, 99 => :quit
  }

  attr_accessor :input, :output

  def initialize(program, input: [])
    @memory = program.each_with_index.to_a.map(&:reverse).to_h
    @memory.default = 0

    @input = input
    @output = []

    @ip = 0
    @relative_base = 0
  end

  def run
    @state = :running

    while @state == :running
      send(OPERATIONS[@memory[@ip] % 100])
    end
  end

  def add
    @memory[actual_address(3)] = actual_value(1) + actual_value(2)
    @ip += 4
  end

  def multiply
    @memory[actual_address(3)] = actual_value(1) * actual_value(2)
    @ip += 4
  end

  def read
    @memory[actual_address(1)] = @input.shift
    @ip += 2
  end

  def write
    @output << actual_value(1)
    @ip += 2
  end

  def jump_unless_zero
    if actual_value(1) != 0
      @ip = actual_value(2)
    else
      @ip += 3
    end
  end

  def jump_if_zero
    if actual_value(1) == 0
      @ip = actual_value(2)
    else
      @ip += 3
    end
  end

  def less_than
    @memory[actual_address(3)] = actual_value(1) < actual_value(2) ? 1 : 0
    @ip += 4
  end

  def equals
    @memory[actual_address(3)] = actual_value(1) == actual_value(2) ? 1 : 0
    @ip += 4
  end

  def adjust_relative_base
    @relative_base += actual_value(1)
    @ip += 2
  end

  def quit
    @state = :terminated
  end

  def actual_address(offset)
    case mode(offset)
    when :relative then @relative_base + value_at(offset)
    when :position then value_at(offset)
    else raise "invalid mode #{mode(offset)}"
    end
  end

  def actual_value(offset)
    case mode(offset)
    when :immediate then value_at(offset)
    else @memory[actual_address(offset)]
    end
  end

  def mode(offset)
    flags = value_at(0).digits.drop(2)

    case flags[offset - 1]
    when 1 then :immediate
    when 2 then :relative
    else :position
    end
  end

  def value_at(offset)
    @memory[@ip + offset]
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
