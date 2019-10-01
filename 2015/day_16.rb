AuntSue = Struct.new(:index, :properties)

requirements = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1
}

aunts = File.readlines("input/day_16").map do |line|
  index, description = /Sue (\d+): ([\w:, ]+)/.match(line)[1..2]
  properties = description.split(", ").map do |property_description|
    property, value = /(\w+): (\d+)/.match(property_description)[1..2]
    [property.to_sym, value.to_i]
  end
  AuntSue.new(index.to_i, properties.to_h)
end

class ExactRequirements
  def initialize(requirements)
    @requirements = requirements
  end

  def match?(properties)
    properties.all? { |key, value| value == @requirements[key] }
  end
end

exact_requirements = ExactRequirements.new(requirements)
right_aunt = aunts.find { |aunt| exact_requirements.match?(aunt.properties) }
puts "Part 1: #{right_aunt.index}"

class CorrectRequirements
  def initialize(requirements)
    @requirements = requirements
  end

  def match?(properties)
    properties.all? do |key, value|
      case key
      when :cats, :trees then value > @requirements[key]
      when :pomeranians, :goldfish then value < @requirements[key]
      else value == @requirements[key]
      end
    end
  end
end

correct_requirements = CorrectRequirements.new(requirements)
real_aunt = aunts.find { |aunt| correct_requirements.match?(aunt.properties) }
puts "Part 2: #{real_aunt.index}"
