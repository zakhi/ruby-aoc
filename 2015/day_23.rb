Operation = Struct.new(:code, :register, :offset)

def run_program(operations, registers)
  current = 0

  while current < operations.size
    operation = operations[current]
    previous = current

    case operation.code
    when "hlf" then registers[operation.register] /= 2
    when "tpl" then registers[operation.register] *= 3
    when "inc" then registers[operation.register] += 1
    when "jmp" then current += operation.offset
    when "jie" then current += operation.offset if registers[operation.register].even?
    when "jio" then current += operation.offset if registers[operation.register] == 1
    end

    current += 1 if current == previous
  end
end

operations = File.readlines("input/day_23").map do |line|
  code, register, offset = /(\w+) ([ab])?(?:, )?([+-]\d+)?/.match(line)[1..3]
  Operation.new(code, register, offset.to_i)
end

registers = { "a" => 0, "b" => 0 }
run_program(operations, registers)
puts "Part 1: #{registers["b"]}"

registers = { "a" => 1, "b" => 0 }
run_program(operations, registers)
puts "Part 2: #{registers["b"]}"


