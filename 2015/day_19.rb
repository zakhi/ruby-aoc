require "../helpers/enumerable"

lines = File.readlines("input/day_19").map(&:chomp)

rules = lines.map { |line| line.match(/(\w+) => (\w+)/) }.compact.map { |match| match[1..2] }
molecule = lines.last

def transformations(molecule, rules)
  transformations = rules.flat_map do |key, value|
    molecule.to_enum(:scan, key).map do
      match = Regexp.last_match
      "#{match.pre_match}#{value}#{match.post_match}"
    end
  end

  transformations.uniq
end

puts "Part 1: #{transformations(molecule, rules).count}"

definition = molecule.gsub(/[A-Z][a-z]?/) do |match|
  case match
  when "Rn", "Ar" then ""
  when "Y" then ","
  else "X"
  end
end

counts = definition.chars.tally

steps = counts["X"] - counts[","] - 1
puts "Part 2: #{steps}"
