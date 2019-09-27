require "set"
require_relative "../common/operations"

lines = File.readlines("input/day_21")
ip_register = lines.shift.match(/#ip (\d+)/)[1].to_i

instructions = lines.map do |line|
  name, a, b, c = line.match(/(\w+) (\d+) (\d+) (\d+)/)[1..4]
  Instruction.new(name.to_sym, a.to_i, b.to_i, c.to_i)
end

def run_process(instructions, registers, ip_register)
  ip = 0

  while ip < instructions.size
    registers[ip_register] = ip
    instructions[ip].run(registers)
    break if registers[ip_register] == 28

    ip = registers[ip_register] + 1
  end
end

registers = [0, 0, 0, 0, 0, 0]
run_process(instructions, registers, ip_register)

puts "Part 1: #{registers[1]}"

registers = [0, 0, 0, 0, 0, 0]
ones = Set[]
last_non_repeating = 0

loop do
  registers[5] = registers[1] | 65536
  registers[1] = 8595037

  loop do
    registers[1] += registers[5] & 255
    registers[1] = ((registers[1] & 16777215) * 65899) & 16777215
    break unless registers[5] >= 256

    registers[5] /= 256
  end

  break if ones.include?(registers[1])

  last_non_repeating = registers[1]
  ones << registers[1]
end

puts "Part 2: #{last_non_repeating}"
