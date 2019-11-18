class Runner
  def initialize
    @registers = Hash.new(0)
  end

  def run(instructions)
    @position = 0

    while @position < instructions.size
      break @recovered_sound if @recovered_sound
      previous_position = @position
      send(*instructions[@position])
      @position += 1 if @position == previous_position
    end
  end

  def snd(x)
    @sound = value_of(x)
  end

  def set(x, y)
    @registers[x] = value_of(y)
  end

  def add(x, y)
    @registers[x] += value_of(y)
  end

  def mul(x, y)
    @registers[x] *= value_of(y)
  end

  def mod(x, y)
    @registers[x] %= value_of(y)
  end

  def rcv(x)
    @recovered_sound = @sound if value_of(x) != 0
  end

  def jgz(x, y)
    @position += value_of(y) if value_of(x) > 0
  end

  def value_of(x)
    x =~ /\d+/ ? x.to_i : @registers[x]
  end
end

instructions = File.readlines("input/day_18").map(&:split)
runner = Runner.new

recovered_sound = runner.run(instructions)
puts "Part 1: #{recovered_sound}"

class Program
  attr_accessor :target
  attr_reader :times_sent

  def initialize(id, instructions)
    @instructions = instructions

    @registers = Hash.new(0)
    @registers["p"] = id

    @queue = []
    @waiting = false
    @position = 0
    @times_sent = 0
  end

  def run
    until @position >= @instructions.size
      previous_position = @position
      send(*@instructions[@position])
      break if waiting?
      @position += 1 if @position == previous_position
    end
  end

  def waiting?
    @waiting
  end

  def <<(value)
    @queue << value
    @waiting = false
  end

  def snd(x)
    @target << value_of(x)
    @times_sent += 1
  end

  def set(x, y)
    @registers[x] = value_of(y)
  end

  def add(x, y)
    @registers[x] += value_of(y)
  end

  def mul(x, y)
    @registers[x] *= value_of(y)
  end

  def mod(x, y)
    @registers[x] %= value_of(y)
  end

  def rcv(x)
    if @queue.empty?
      @waiting = true
    else
      @waiting = false
      @registers[x] = @queue.shift
    end
  end

  def jgz(x, y)
    @position += value_of(y) if value_of(x) > 0
  end

  def value_of(x)
    x =~ /\d+/ ? x.to_i : @registers[x]
  end
end

program_0 = Program.new(0, instructions)
program_1 = Program.new(1, instructions)

program_0.target = program_1
program_1.target = program_0

until program_0.waiting? && program_1.waiting?
  program_0.run
  program_1.run
end

puts "Part 2: #{program_1.times_sent}"
