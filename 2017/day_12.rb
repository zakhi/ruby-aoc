require "set"

links = Hash.new { |h, k| h[k] = [] }

File.readlines("input/day_12").map do |line|
  source, targets = /(\d+) <-> ([\d ,]+)/.match(line)[1..2]
  destinations = targets.split(", ").map(&:to_i)
  links[source.to_i].push(*destinations)
end

groups = []
programs = links.keys.to_a

until programs.empty?
  queue = [programs.pop]
  group = Set[]

  until queue.empty?
    program = queue.pop
    group << program
    programs.delete(program)

    linked_programs = links[program]
    linked_programs.each { |p| queue << p unless group.include?(p) }
  end

  groups << group
end

group0 = groups.find { |g| g.include?(0) }

puts "Part 1: #{group0.size}"
puts "Part 2: #{groups.size}"
