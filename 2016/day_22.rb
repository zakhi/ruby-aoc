require_relative "../helpers/queue"

class Node
  attr_reader :name, :size, :used, :coordinates

  def initialize(name, size, used)
    @name, @size, @used = name, size, used
    @coordinates = name.match(/x(\d+)-y(\d+)/)[1..2].map(&:to_i)
  end

  def empty?
    @used == 0
  end

  def available
    @size - @used
  end

  def to_s
    "#{name}: #{used}/#{size}"
  end
end

nodes = File.readlines("input/day_22").drop(2).map do |line|
  match = /([\w\/-]+)\s+(\d+)T\s+(\d+)T/.match(line)
  Node.new(match[1], match[2].to_i, match[3].to_i)
end

viable_pairs = nodes.permutation(2).count do |a, b|
  !a.empty? && b.available >= a.used
end

puts "Part 1: #{viable_pairs}"

DistanceNode = Struct.new(:node, :distance) do
  include Comparable

  def <=>(other)
    self.distance <=> other.distance
  end
end

nodes_by_position = nodes.reject { |n| n.used > 100 }.map { |n| [n.coordinates, n] }.to_h
source = nodes.find(&:empty?)

queue = MinimumQueue.new
queue << DistanceNode.new(source, 0)

visited = Set[]

distance_to_target = until queue.empty?
  node, distance = *queue.pop
  break distance if node.coordinates == [30, 0]
  next unless visited.add?(node.coordinates)

  neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]]
    .map { |offset| node.coordinates.zip(offset).map(&:sum) }
    .map { |position| nodes_by_position[position] }.compact

  neighbors.each do |neighbor|
    queue << DistanceNode.new(neighbor, distance + 1)
  end
end

total_distance = distance_to_target + 30 * 5 + 1
puts "Part 2: #{total_distance}"
