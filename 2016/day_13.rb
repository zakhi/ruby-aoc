require "set"
require_relative "../helpers/queue"

INPUT = 1364

class Maze
  Position = Struct.new(:position, :distance) do
    include Comparable

    def <=>(other)
      self.distance <=> other.distance
    end
  end

  def steps(from:, to:)
    scan(from) do |position, distance|
      if position == to
        distance
      end
    end
  end

  def reachable_locations(from:, steps:)
    visited = Set[]

    scan(from, visited) do |_, distance|
      if distance > steps
        visited.size
      end
    end
  end

  def scan(from, visited = Set[])
    queue = MinimumQueue.new
    queue << Position.new(from, 0)

    distances = Hash.new(1000)
    distances[from] = 0

    until queue.empty?
      position, distance = *queue.pop
      result = yield [position, distance]

      break result if result
      next unless visited.add?(position)

      neighbors_of(position).reject { |neighbor| visited.include?(neighbor) }.each do |neighbor|
        neighbor_distance = distance + 1
        if distances[neighbor] > neighbor_distance
          distances[neighbor] = neighbor_distance
          queue << Position.new(neighbor, neighbor_distance)
        end
      end
    end
  end

  private

  def neighbors_of(position)
    candidates = [[-1, 0], [1, 0], [0, -1], [0, 1]].map { |offset| position.zip(offset).map(&:sum) }
    candidates.reject { |p| p.any?(&:negative?) || wall?(*p) }
  end

  def wall?(x, y)
    number = INPUT + x * x + 3 * x + 2 * x * y + y + y * y
    number.to_s(2).count("1").odd?
  end
end

maze = Maze.new
puts "Part 1: #{maze.steps(from: [1, 1], to: [31, 39])}"
puts "Part 1: #{maze.reachable_locations(from: [1, 1], steps: 50)}"
