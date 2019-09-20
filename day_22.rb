require "set"
require_relative "helpers/queue"

class Array
  alias_method :x, :first
  alias_method :y, :last
end

Region = Struct.new(:position, :type, :equipment) do
  def neighbors(cave)
    positions = [[-1, 0], [1, 0], [0, -1], [0, 1]]
      .map { |offset| [position.x + offset.x, position.y + offset.y] }
      .reject { |position| position.x < 0 || position.y < 0 }

    neighbors = positions.map { |position| [position, cave.type(position)] }
      .select { |position, type| valid_equipments(type).include?(equipment) }
      .map { |position, type| Region.new(position, type, equipment) }
    
    neighbors + [Region.new(position, type, alternate_equipment)]
  end

  def valid_equipments(type)
    case type
    when :rocky then [:torch, :climbing]
    when :wet then [:climbing, :neither]
    when :narrow then [:torch, :neither]
    end
  end

  def alternate_equipment
    valid_equipments(type).find { |e| e != equipment }
  end
end

TimedRegion = Struct.new(:region, :time) do
  include Comparable

  def <=>(other)
    self.time <=> other.time
  end
end

class Cave
  def initialize(depth, target)
    @depth, @target = depth, target
    @erosion_levels = {}
  end
  
  def risk_level
    (0..@target.x).to_a.product((0..@target.y).to_a).sum { |region| erosion_level(region) % 3 }
  end

  def geo_index(region)
    case
    when region == [0, 0] || region == @target then 0
    when region.x == 0 then region.y * 48271
    when region.y == 0 then region.x * 16807
    else erosion_level([region.x - 1, region.y]) * erosion_level([region.x, region.y - 1])
    end
  end

  def erosion_level(region)
    @erosion_levels[region] ||= (geo_index(region) + @depth) % 20183
  end

  def type(position)
    [:rocky, :wet, :narrow][erosion_level(position) % 3]
  end
end

input = File.read("input/day_22")
depth = /depth: (\d+)/.match(input)[1].to_i
target = /target: (\d+),(\d+)/.match(input)[1..2].map(&:to_i)

cave = Cave.new(depth, target)
puts "Part 1: #{cave.risk_level}"

start = Region.new([0, 0], cave.type([0, 0]), :torch)
destination = Region.new(target, cave.type(target), :torch)

minimum_times = Hash.new(10000000)
minimum_times[start] = 0
visited = Set[]

queue = MinimumQueue.new
queue.push(TimedRegion.new(start, 0))

until queue.empty?
  current_region, current_time = *queue.pop
  break if current_region == destination
  
  next if visited.include?(current_region)
  visited << current_region

  current_region.neighbors(cave).reject { |r| visited.include?(r) }.each do |neighbor_region|
    new_time = current_time + (current_region.equipment == neighbor_region.equipment ? 1 : 7)
    if minimum_times[neighbor_region] > new_time
      minimum_times[neighbor_region] = new_time
      queue.push(TimedRegion.new(neighbor_region, new_time))
    end
  end
end

puts "Part 2: #{minimum_times[destination]}"
