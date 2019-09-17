require_relative "common/operations"

lines = File.readlines("input/day_19")
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
    ip = registers[ip_register] + 1
  end
end

registers = [0, 0, 0, 0, 0, 0]
run_process(instructions, registers, ip_register)

puts "Part 1: #{registers[0]}"

def divisors_sum(num)
  (1..num).lazy.select { |i| num % i == 0 }.sum
end 

puts "Part 2: #{divisors_sum(10551340)}"
