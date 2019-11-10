require_relative "../helpers/enumerable"

weights = {}
holdings = Hash.new { |h, k| h[k] = [] }

File.readlines("input/day_7").map do |line|
  program, weight, sub_programs = /(\w+) \((\d+)\)(?: -> ([\w ,]+))?/.match(line)[1..3]
  weights[program] = weight.to_i

  if sub_programs
    holdings[program].push(*sub_programs.split(", "))
  end
end

class Tower
  def initialize(weights, holdings)
    @weights, @holdings = weights, holdings
    @total_weights = {}

    held_programs = holdings.flat_map(&:last).uniq
    @root = holdings.keys.find { |program| !held_programs.include?(program) }

    calculate_total_weight(@root)
  end

  def bottom_program
    @root
  end

  def required_balancing_weight
    odd_program, weight_difference = odd_child_program(@root)
    weight_difference + @weights[find_balancing_program(odd_program)]
  end

  def calculate_total_weight(program)
    @total_weights[program] ||= @weights[program] + @holdings[program].sum { |sub| calculate_total_weight(sub) }
  end

  def find_balancing_program(program)
    odd_program, weight_difference = odd_child_program(program)
    weight_difference == 0 ? program : find_balancing_program(odd_program)
  end

  def odd_child_program(program)
    weight_counts = @holdings[program].map { |p| @total_weights[p] }.tally
    odd_weight = weight_counts.find { |*, v| v == 1 }&.first
    return [nil, 0] unless odd_weight

    common_weight = weight_counts.find { |*, v| v > 1 }.first
    [@holdings[program].find { |p| @total_weights[p] == odd_weight }, common_weight - odd_weight]
  end
end

tower = Tower.new(weights, holdings)

puts "Part 1: #{tower.bottom_program}"
puts "Part 2: #{tower.required_balancing_weight}"
