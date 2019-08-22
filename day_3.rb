require_relative "helpers/grid"
require_relative "helpers/enumerable"

class Claim < Grid
  attr_reader :id

  def initialize(id, left, top, width, height)
    @id = id
    x_range = left...(left + width)
    y_range = top...(top + height)
    super(x_range, y_range)
  end
end

claims = File.readlines("input/day_3").map do |line|
  match = /#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/.match(line)
  Claim.new(match[:id], match[:left].to_i, match[:top].to_i, match[:width].to_i, match[:height].to_i)
end

square_overlaps = claims.flat_map(&:to_a).tally

overlaps = square_overlaps.values.count { |v| v >= 2 }
puts "Part 1: #{overlaps}"

non_overlapping_claim = claims.find do |claim|
  claim.all? { |square| square_overlaps[square] == 1 }
end

puts "Part 2: #{non_overlapping_claim.id}"
