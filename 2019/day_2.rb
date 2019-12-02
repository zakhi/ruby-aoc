def run_program(memory)
  ip = 0

  while memory[ip] != 99
    first, second, result = memory[ip + 1, 3]
    memory[result] = case memory[ip]
      when 1 then memory[first] + memory[second]
      when 2 then memory[first] * memory[second]
    end

    ip += 4
  end

  memory[0]
end

source = File.read("input/day_2").chomp.split(",").map(&:to_i)

program = source.clone
program[1] = 12
program[2] = 2

puts "Part 1: #{run_program(program)}"

match = 10000.times.find do |value|
  program = source.clone
  program[1] = value / 100
  program[2] = value % 100

  run_program(program) == 19690720
end

puts "Part 2: #{match}"
