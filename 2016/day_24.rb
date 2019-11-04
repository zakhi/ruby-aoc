require "set"
require_relative "../helpers/queue"

class RobotRoutes
  def initialize(grid, points)
    @grid, @points = grid, points
    @distances = {}
    calculate_distances
  end

  def minimum_steps(return_home: false)
    routes = @points[1..].map do |end_point|
      cost_to(end_point) + (return_home ? @distances[Set[@points.first, end_point]] : 0)
    end

    routes.min
  end

  private

  PointWithDistance = Struct.new(:point, :distance) do
    include Comparable

    def <=>(other)
      self.distance <=> other.distance
    end
  end

  def calculate_distances
    @points.size.times do |i|
      queue = MinimumQueue.new
      queue << PointWithDistance.new(@points[i], 0)

      visited = Set[]
      unvisited_points = @points[i + 1..].each_with_index.to_h

      until queue.empty?
        point, distance = *queue.pop
        next unless visited.add?(point)

        unvisited_index = unvisited_points[point]

        if unvisited_index
          @distances[Set[@points[i], @points[i + unvisited_index + 1]]] = distance
          unvisited_points.delete(point)
        end

        break if unvisited_points.empty?

        neighbors_of(point).each do |neighbor|
          queue << PointWithDistance.new(neighbor, distance + 1)
        end
      end
    end
  end

  def neighbors_of(point)
    [[-1, 0], [1, 0], [0, -1], [0, 1]].map { |offset| offset.zip(point).map(&:sum) }.select { |p| @grid.include?(p) }
  end

  def cost_to(end_point, points = @points.to_set)
    return @distances[points] if points.size == 2

    alternative_costs = points.reject { |p| p == @points.first || p == end_point }.map do |prev_end_point|
      cost_to(prev_end_point, points - [end_point]) + @distances[Set[prev_end_point, end_point]]
    end

    alternative_costs.min
  end
end

grid = Set[]
points = []

File.readlines("input/day_24").each_with_index do |line, y|
  line.each_char.with_index do |c, x|
    points[c.to_i] = [x, y] if c =~ /\d/
    grid << [x, y] unless c == "#"
  end
end

routes = RobotRoutes.new(grid, points)

puts "Part 1: #{routes.minimum_steps}"
puts "Part 2: #{routes.minimum_steps(return_home: true)}"
