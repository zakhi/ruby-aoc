class Computer
  attr_reader :registers

  def initialize(program)
    @program = program.map(&:clone)
    @registers = ("a".."d").map { |r| [r, 0] }.to_h
  end

  def run
    @ip = 0

    while @ip < @program.length
      previous_ip = @ip
      send(*@program[@ip])
      @ip += 1 if @ip == previous_ip
    end
  end

  def cpy(x, y)
    @registers[y] = number_or_value(x) if @registers.include?(y)
  end

  def inc(x)
    @registers[x] += 1
  end

  def dec(x)
    @registers[x] -= 1
  end

  def jnz(x, y)
    @ip += number_or_value(y) if number_or_value(x) != 0
  end

  def tgl(x)
    index = @ip + number_or_value(x)
    instruction, *arguments = (@program[index] or return)

    @program[index] = if arguments.size == 1
      [instruction == "inc" ? "dec" : "inc", *arguments]
    else
      [instruction == "jnz" ? "cpy" : "jnz", *arguments]
    end
  end

  def number_or_value(x)
    x =~ /-?\d+/ ? x.to_i : @registers[x]
  end
end

instructions = File.readlines("input/day_23").map do |line|
  /(\w+) (-?\w+) ?(-?\w*)/.match(line)[1..].reject(&:empty?)
end

computer = Computer.new(instructions)
computer.registers["a"] = 7
computer.run

puts "Part 1: #{computer.registers["a"]}"

fast_result = (1..12).inject(&:*) + 78 * 99
puts "Part 2: #{fast_result}"
