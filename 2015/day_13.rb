require "set"

happiness = Hash.new(0)
family = Set[]

File.readlines("input/day_13").each do |line|
  match = /(\w+) would (lose|gain) (\d+) happiness units by sitting next to (\w+)/.match(line)
  people = match.values_at(1, 4).to_set
  change = match[3].to_i * (match[2] == "lose" ? -1 : 1)
  family.merge(people)
  happiness[people] += change
end

def max_happiness(people, happiness)
  arrangement_happiness_levels = people.to_a.permutation(people.size).map do |arrangement|
    neighboring_pairs = arrangement.each_cons(2) + [[arrangement[0], arrangement[-1]]]
    neighboring_pairs.sum { |a, b| happiness[Set[a, b]] }
  end
  arrangement_happiness_levels.max
end

puts "Part 1: #{max_happiness(family, happiness)}"
puts "Part 2: #{max_happiness(family + ["Me"], happiness)}"

