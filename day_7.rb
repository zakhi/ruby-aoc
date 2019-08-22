precedences = Hash.new { |hash, key| hash[key] = [] }

File.readlines("input/day_7").map do |line|
  first, second = /Step (\w) must be finished before step (\w) can begin/.match(line).to_a.drop(1)
  precedences[second] << first
end

steps_left = precedences.values.flat_map(&:itself).uniq.sort
steps_taken = []

while !steps_left.empty?
  next_step = steps_left.find do |step| 
    precedences[step].all? { |preceding| steps_taken.include? preceding }
  end
  steps_taken << steps_left.delete(next_step)
end

puts "#{steps_taken.join}"
