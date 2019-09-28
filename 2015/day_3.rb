require "set"

class PresentGiver
  attr_reader :visited

  def initialize(start_position)
    @position = start_position
    @visited = Set[start_position]
  end

  def move(offset)
    @position = @position.zip(offset).map(&:sum)
    @visited << @position
  end
end

offsets = File.read("input/day_3").chomp.each_char.map do |direction|
  case direction
  when "^" then [0, 1]
  when "v" then [0, -1]
  when ">" then [1, 0]
  when "<" then [-1, 0]
  end
end

santa = PresentGiver.new([0, 0])
offsets.each { |offset| santa.move(offset) }

puts "Part 1: #{santa.visited.count}"

santa = PresentGiver.new([0, 0])
robot = PresentGiver.new([0, 0])

offsets.zip([santa, robot].cycle).each { |offset, giver| giver.move(offset) }

puts "Part 2: #{(santa.visited + robot.visited).count}"
