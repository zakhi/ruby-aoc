require "strscan"
require_relative "common/operations"

class Sample
  attr_reader :code

  def initialize(before, op, after)
    @before, @after = before, after
    @code = op[0]
    @params = op[1..3]
  end

  def fits(operation)
    regs = @before.clone
    operation[*@params, regs]
    regs == @after
  end
end

samples = []
scanner = StringScanner.new(File.read("input/day_16"))

while scanner.scan(/Before: \[(\d+, \d+, \d+, \d+)\]\n(\d+ \d+ \d+ \d+)\nAfter:  \[(\d+, \d+, \d+, \d+)\]\n\n/)
  before, after = scanner.values_at(1, 3).map { |s| s.split(", ").map(&:to_i) }
  op = scanner.values_at(2).map(&:split).flatten.map(&:to_i)
  samples << Sample.new(before, op, after)
end

sample_matches = samples.map { |sample| [sample, OPERATIONS.select { |*, op| sample.fits(op) }.map(&:first)] }

puts "Part 1: #{sample_matches.count { |*, matches| matches.count >= 3 }}"

operation_names = {}
id_matches = sample_matches.map { |sample, names| [sample.code, names] }

until id_matches.empty?
  id_matches.uniq!
  unique_matches = id_matches.select { |id, names| names.count == 1 }
  resolved_id = unique_matches.map(&:first)

  operation_names.merge!(Hash[unique_matches.map { |id, (name)| [id, name] }])
  id_matches.delete_if { |id, *| resolved_id.include?(id) }
  
  new_unique_names = unique_matches.map { |*, (name)| name }
  id_matches.each { |*, names| new_unique_names.each { |name| names.delete(name) } }
end

scanner.scan /\n\n/
registers = [0, 0, 0, 0]

while scanner.scan /(\d+) (\d+) (\d+) (\d+)\n/
  id, a, b, c = scanner.values_at(*1..4).map(&:to_i)
  operation = OPERATIONS[operation_names[id]]
  operation.call(a, b, c, registers)
end

puts "Part 2: #{registers[0]}"
