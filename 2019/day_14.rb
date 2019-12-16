Chemical = Struct.new(:type, :quantity) do
  def with_quantity(amount)
    Chemical.new(type, amount)
  end
end

Formula = Struct.new(:input, :output) do
  def transform(amount)
    times = (amount.to_f / output.quantity).ceil.to_i
    result = input.map { |c| c.with_quantity(c.quantity * times) }
    result + [output.with_quantity(- times * output.quantity)]
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
puts "Part 1: #{factory.amount_needed_for(Chemical.new("FUEL", 1))}"
