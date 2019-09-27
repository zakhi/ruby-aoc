require "set"

class Point
  attr_reader :id, :coordinates

  def initialize(id, coordinates)
    @id, @coordinates = id, coordinates
  end

  def close_to(other)
    self.coordinates.zip(other.coordinates).map { |a, b| (a - b).abs }.sum <= 3
  end
end

class Constellations
  def initialize(points, neighbors)
    @points, @neighbors = points, neighbors
  end

  def count
    constellations = []
    left = @points.clone

    until left.empty?
      current = []
      add(current, left.pop)
      constellations << current
      left -= current
    end

    constellations.count
  end

  def add(group, point)
    return if group.include?(point)
    group << point
    @neighbors[point].each { |neighbor| add(group, neighbor) }
  end
end

points = File.readlines("input/day_25").map.with_index do |line, id|
  coordinates = /(-?\d+),(-?\d+),(-?\d+),(-?\d+)/.match(line)[1..4].map(&:to_i)
  Point.new(id, coordinates)
end

neighbors = Hash.new { |h, k| h[k] = [] }
points.combination(2).select { |a, b| a.close_to(b) }.each do |a, b|
  neighbors[a.id] << b.id
  neighbors[b.id] << a.id
end

total = Constellations.new(points.map(&:id), neighbors).count
puts "Part 1: #{total}"
