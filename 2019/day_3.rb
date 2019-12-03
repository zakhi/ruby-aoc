require "set"

class Wire
  def initialize(path)
    @point_distances = {}
    travel(path)
  end

  def points
    @point_distances.keys.to_set
  end

  def distance_to(point)
    @point_distances[point]
  end

  private

  def travel(path)
    current = [0, 0]
    steps_traveled = 0

    path.each do |direction, steps|
      steps.times do
        offset = case direction
          when "U" then [0, 1]
          when "D" then [0, -1]
          when "L" then [-1, 0]
          when "R" then [1, 0]
        end

        current = current.zip(offset).map(&:sum)
        steps_traveled += 1
        @point_distances[current] ||= steps_traveled
      end
    end
  end
end

wires = File.readlines("input/day_3").map do |line|
  path = line.scan(/(\w)(\d+)/).map { |direction, steps| [direction, steps.to_i] }
  Wire.new(path)
end

common_points = wires.map(&:points).reduce(&:intersection)
common_points_distances = common_points.map { |point| point.map(&:abs).sum }

puts "Part 1: #{common_points_distances.min}"

combined_steps = common_points.map do |point|
  wires.sum { |wire| wire.distance_to(point) }
end

puts "Part 2: #{combined_steps.min}"
