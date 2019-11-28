require "prime"

class Processor
  attr_reader :registers, :mul_invoked

  def initialize
    @registers = ("a".."h").map { |r| [r, 0] }.to_h
    @mul_invoked = 0
  end

  def run(instructions)
    @position = 0

    while @position < instructions.size
      previous_position = @position
      send(*instructions[@position])
      @position += 1 if @position == previous_position
    end
  end

  def set(x, y)
    @registers[x] = value_of(y)
  end

  def sub(x, y)
    @registers[x] -= value_of(y)
  end

  def mul(x, y)
    @registers[x] *= value_of(y)
    @mul_invoked += 1
  end

  def jnz(x, y)
    @position += value_of(y) if value_of(x) != 0
  end

  def value_of(x)
    x =~ /-?\d+/ ? x.to_i : @registers[x]
  end
end

instructions = File.readlines("input/day_23").map(&:split)
processor = Processor.new
processor.run(instructions)

puts "Part 1: #{processor.mul_invoked}"

h = 106500.step(by: 17, to: 123500).count { |i| !Prime.prime?(i) }
puts "Part 2: #{h}"
