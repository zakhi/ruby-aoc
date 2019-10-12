require "set"

class Walk
  DIRECTIONS = [[0, 1], [1, 0], [0, -1], [-1, 0]]

  def initialize
    @visited_coordinates = [[0, 0]]
    @direction_index = 0
  end

  def current_distance
    distance(@visited_coordinates.last)
  end

  def turn_and_walk(turn, distance)
    @direction_index = case turn
      when :left then (@direction_index - 1) % DIRECTIONS.size
      when :right then (@direction_index + 1) % DIRECTIONS.size
    end

    distance.times do
      @visited_coordinates << @visited_coordinates.last.zip(DIRECTIONS[@direction_index]).map(&:sum)
    end
  end

  def first_revisited_distance
    @visited_coordinates.each_with_object(Set[]) do |location, visited|
      break distance(location) if visited.include?(location)
      visited << location
    end
  end

  private

  def distance(coordinates)
    coordinates.map(&:abs).sum
  end
end

turns = File.read("input/day_1").scan(/([LR])(\d+)/).map do |turn, distance|
  turn_direction = case turn
  when "L" then :left
  when "R" then :right
  end
  [turn_direction, distance.to_i]
end

walk = Walk.new
turns.each { |turn, distance| walk.turn_and_walk(turn, distance) }

puts "Part 1: #{walk.current_distance}"
puts "Part 2: #{walk.first_revisited_distance}"
