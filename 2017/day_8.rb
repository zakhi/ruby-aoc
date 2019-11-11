class Condition
  def initialize(register, operator, value)
    @register, @operator, @value = register, operator, value
  end

  def true?(registers)
    registers[@register].send(@operator, @value)
  end
end

class Instruction
  def initialize(register, change, condition)
    @register, @change, @condition = register, change, condition
  end

  def perform(registers)
    registers[@register] += @change if @condition.true?(registers)
  end
end

instructions = File.readlines("input/day_8").map do |line|
  match = /(\w+) (inc|dec) (-?\d+) if (\w+) ([=!><]+) (-?\d+)/.match(line)
  Instruction.new(match[1], (match[2] == "inc" ? 1 : -1) * match[3].to_i, Condition.new(match[4], match[5], match[6].to_i))
end

registers = Hash.new(0)
max_memory = 0

instructions.each do |instruction|
  instruction.perform(registers)
  max_memory = [max_memory, registers.values.max || 0].max
end

puts "Part 1: #{registers.values.max}"
puts "Part 2: #{max_memory}"
