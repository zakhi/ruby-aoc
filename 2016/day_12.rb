Instruction = Struct.new(:code, :x, :y)

OPERATIONS = {
  cpy: -> (registers, x, y) { registers[y] = (x =~ /-?\d+/ ? x.to_i : registers[x]) },
  inc: -> (registers, x, _) { registers[x] += 1 },
  dec: -> (registers, x, _) { registers[x] -= 1 },
  jnz: -> (registers, x, y) do
    value = x =~ /-?\d+/ ? x : registers[x]
    value != 0 ? y.to_i : 1
  end
}

instructions = File.readlines("input/day_12").map do |line|
  code, x, y = /(\w+) (-?\w+) ?(-?\w*)/.match(line)[1..3]
  Instruction.new(code.to_sym, x, y)
end

def run_program(instructions, registers)
  ip = 0

  while ip < instructions.size
    current_instruction = instructions[ip]
    operation = OPERATIONS[current_instruction.code]

    result = operation.call(registers, current_instruction.x, current_instruction.y)
    ip += current_instruction.code == :jnz ? result : 1
  end
end

registers = { "a" => 0, "b" => 0, "c" => 0, "d" => 0 }
run_program(instructions, registers)

puts "Part 1: #{registers["a"]}"

real_registers = { "a" => 0, "b" => 0, "c" => 1, "d" => 0 }
run_program(instructions, real_registers)

puts "Part 1: #{real_registers["a"]}"
