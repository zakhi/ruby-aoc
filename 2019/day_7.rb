class Amplifier
  OPERATIONS = {
    1 => :add, 2 => :multiply, 3 => :read, 4 => :write,
    5 => :jump_unless_zero, 6 => :jump_if_zero, 7 => :less_than, 8 => :equals,
    99 => :quit
  }

  attr_reader :input
  attr_accessor :output

  def initialize(phase, program)
    @memory = program.each_with_index.to_a.map(&:reverse).to_h
    @input = [phase]
    @output = []
    @ip = 0
    @state = :waiting
  end

  def can_run?
    @state == :waiting && !@input.empty?
  end

  def terminated?
    @state == :terminated
  end

  def run
    return if @state == :terminated
    @state = :running

    while @state == :running
      send(OPERATIONS[@memory[@ip] % 100])
    end
  end

  def add
    @memory[value_at(3)] = actual_value(1) + actual_value(2)
    @ip += 4
  end

  def multiply
    @memory[value_at(3)] = actual_value(1) * actual_value(2)
    @ip += 4
  end

  def read
    if @input.empty?
      @state = :waiting
    else
      @memory[value_at(1)] = @input.shift
      @ip += 2
    end
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
    @memory[value_at(3)] = actual_value(1) < actual_value(2) ? 1 : 0
    @ip += 4
  end

  def equals
    @memory[value_at(3)] = actual_value(1) == actual_value(2) ? 1 : 0
    @ip += 4
  end

  def quit
    @state = :terminated
  end

  def actual_value(offset)
    value = value_at(offset)
    flags = @memory[@ip].digits.drop(2)
    flags[offset - 1] == 1 ? value : @memory[value]
  end

  def value_at(offset)
    @memory[@ip + offset]
  end
end

def combine(phases, source, feedback_loop: false)
  amps = phases.map { |phase| Amplifier.new(phase, source) }
  amps.each_cons(2) { |first, second| first.output = second.input }
  amps.last.output = amps.first.input if feedback_loop

  amps.first.input << 0

  until amps.all?(&:terminated?)
    amps.find(&:can_run?).run
  end

  amps.last.output.last
end

source = File.read("input/day_7").chomp.split(",").map(&:to_i)

signals = (0..4).to_a.permutation(5).map { |phases| combine(phases, source) }
puts "Part 1: #{signals.max}"

enhanced_signals = (5..9).to_a.permutation(5).map { |phases| combine(phases, source, feedback_loop: true) }
puts "Part 2: #{enhanced_signals.max}"
