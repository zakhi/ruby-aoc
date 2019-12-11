class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def angle_to(origin)
    -Math::atan2(@x - origin.x, @y - origin.y)
  end

  def distance_from(origin)
    Math::sqrt((@x - origin.x) ** 2 + (@y - origin.y) ** 2)
  end
end

class Array
  def mixed_transpose
    filler = [nil] * map(&:size).max
    [filler, *self].inject(&:zip).flatten.compact
  end
end

positions = File.readlines("input/day_10").flat_map.with_index do |line, y|
  line.chomp.each_char.with_index.select { |c, *| c == "#" }.map { |*, x| Point.new(x, y) }
end

detections = positions.map do |position|
  [position, positions.reject { |p| p == position }.map { |other| other.angle_to(position) }.uniq.count]
end

station, detected = detections.max_by(&:last)
puts "Part 1: #{detected}"

asteroids = positions.reject { |p| p == station }
groups = asteroids.group_by { |a| a.angle_to(station) }.sort_by(&:first).map { |*, group| group.sort_by { |a| a.distance_from(station)  } }
vaporized_order = groups.mixed_transpose

asteroid_200 = vaporized_order[199]
puts "Part 2: #{asteroid_200.x * 100 + asteroid_200.y}"
