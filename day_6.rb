require_relative("helpers/grid")

class Point
  def closest_points
    @closest ||= []
  end
end

class Grid
  def on_edge(point)
    point.x == @xs.begin || point.x == @xs.end ||
    point.y == @ys.begin || point.y == @ys.end
  end
end

points = File.readlines("input/day_6").map do |line|
  x, y = /(\d+), (\d+)/.match(line)[1..2].map(&:to_i)
  Point.new(x, y)
end

x_range = Range.new(*points.map(&:x).minmax)
y_range = Range.new(*points.map(&:y).minmax)
grid = Grid.new(x_range, y_range)

grid.each do |location|
  *, closest = points.group_by { |p| p.distance_to(location) }.min
  closest.first.closest_points << location if closest.length == 1
end

points_with_finite_area = points.select do |point|
  point.closest_points.all? { |p| !grid.on_edge(p) }
end

max_area = points_with_finite_area.map { |p| p.closest_points.length }.max
puts "Part 1: #{max_area}"

expand_size = 10000 / (points.size - 1)
safe_x_range = (x_range.begin - expand_size .. x_range.end + expand_size)
safe_y_range = (y_range.begin - expand_size .. y_range.end + expand_size)

safe_grid = Grid.new(safe_x_range, safe_y_range)

safe_area = safe_grid.count do |location|
  points.sum { |p| p.distance_to(location) } < 10000
end

puts "Part 2: #{safe_area}"
