Chemical = Struct.new(:type, :quantity) do
  def with_quantity(amount)
    Chemical.new(type, amount)
  end
end

Formula = Struct.new(:input, :output) do
  def transform(amount)
    times = (amount.to_f / output.quantity).ceil.to_i
    result = input.map { |c| c.with_quantity(c.quantity * times) }
    result + [output.with_quantity(-1 * times * output.quantity)]
  end
end

class NanoFactory
  def initialize(formulas)
    @formulas = formulas
  end

  def amount_needed_for(chemical)
    @amounts = Hash.new(0)
    @amounts[chemical.type] = chemical.quantity

    until only_ore?
      current_output = next_chemical
      formula = @formulas.find { |f| f.output.type == current_output.type }
      formula.transform(current_output.quantity).each do |c|
        @amounts[c.type] += c.quantity
      end
    end

    @amounts["ORE"]
  end

  def only_ore?
    remaining_chemicals.keys == ["ORE"]
  end

  def next_chemical
    type, quantity = remaining_chemicals.reject { |k, *| k == "ORE" }.first
    Chemical.new(type, quantity)
  end

  def remaining_chemicals
    @amounts.select { |*, v| v.positive? }
  end
end

def chemical_from(text)
  quantity, type = /(\d+) (\w+)/.match(text)[1..2]
  Chemical.new(type, quantity.to_i)
end

formulas = File.readlines("input/day_14").map do |line|
  input, output = /([\w, ]+) => ([\w ]+)/.match(line)[1..2]
  Formula.new(input.split(", ").map { |single| chemical_from(single) }, chemical_from(output))
end

factory = NanoFactory.new(formulas)
ore_needed_per_fuel = factory.amount_needed_for(Chemical.new("FUEL", 1))
puts "Part 1: #{ore_needed_per_fuel}"

fuel_floor = 10 ** 12 / ore_needed_per_fuel
fuel_ceiling = 10 ** 13 / ore_needed_per_fuel

while fuel_floor < fuel_ceiling
  fuel = (fuel_floor + fuel_ceiling) / 2
  break if fuel == fuel_floor

  ore = factory.amount_needed_for(Chemical.new("FUEL", fuel))

  fuel_ceiling = fuel if ore >= 10 ** 12
  fuel_floor = fuel if ore <= 10 ** 12
end

puts "Part 2: #{fuel_floor}"
