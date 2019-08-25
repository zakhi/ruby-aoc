Coordinate = Struct.new(:x, :y) do
  def to_s
    "<#{x}, #{y}>"
  end

  def distance_to(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end

  def closest_coordinates
    @closest ||= []
  end

  def area
    closest_coordinates.length
  end
end

class Grid
  def initialize(coordinates)
    @coordinates = coordinates
    @xs = Range.new(*coordinates.map(&:x).minmax)
    @ys = Range.new(*coordinates.map(&:y).minmax)

    all_locations.each do |location|
      *, closest = @coordinates.group_by { |c| c.distance_to(location) }.min
      closest.first.closest_coordinates << location if closest.length == 1
    end
  end

  def largest_area_coordinate
    @coordinates.select { |c| !in_edge(c) }.max_by(&:area)
  end

  def all_locations
    @xs.to_a.product(@ys.to_a).map { |x, y| Coordinate.new(x, y) }
  end  
  
  def in_edge(coordinate)
    coordinate.closest_coordinates.any? do |location|
      location.x == @xs.begin || location.x == @xs.end ||
      location.y == @ys.begin || location.y == @ys.end
    end
  end
end

coordinates = File.readlines("input/day_6").map do |line|
  x, y = /(\d+), (\d+)/.match(line).to_a.drop(1).map(&:to_i)
  Coordinate.new(x, y)
end

grid = Grid.new(coordinates)

puts "Part 1: #{grid.largest_area_coordinate.area}"