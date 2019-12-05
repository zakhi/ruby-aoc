class Program
  attr_reader :output

  def initialize(source)
    @memory = source.each_with_index.to_a.map(&:reverse).to_h
  end

  def run(input)
    output = []
    @ip = 0

    until @memory[@ip] == 99
      instruction = @memory[@ip] % 100

      case instruction
      when 1 then @memory[value_at(3)] = actual_value(1) + actual_value(2)
      when 2 then @memory[value_at(3)] = actual_value(1) * actual_value(2)
      when 3 then @memory[value_at(1)] = input.shift
      when 4 then output << actual_value(1)
      when 5 then @ip = actual_value(1) != 0 ? actual_value(2) : @ip + 3
      when 6 then @ip = actual_value(1) == 0 ? actual_value(2) : @ip + 3
      when 7 then @memory[value_at(3)] = actual_value(1) < actual_value(2) ? 1 : 0
      when 8 then @memory[value_at(3)] = actual_value(1) == actual_value(2) ? 1 : 0
      end

      @ip += case instruction
      when 3..4 then 2
      when 5..6 then 0
      else 4
      end
    end

    output
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

source = File.read("input/day_5").chomp.split(",").map(&:to_i)
puts "Part 1: #{Program.new(source).run([1]).last}"
puts "Part 2: #{Program.new(source).run([5]).last}"
