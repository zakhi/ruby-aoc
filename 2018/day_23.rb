require "set"

class Array
  alias_method :x, :first  
  alias_method :z, :last  

  def y
    self[1]
  end
end

NanoBot = Struct.new(:id, :center, :radius) do
  def distance_from(other)
    center.zip(other.center).map { |a, b| (a - b).abs }.sum
  end

  def intersects_with(other)
    distance_from(other) <= self.radius + other.radius
  end

  def shortest_distance
    return 0 if center.x.abs <= radius
    center.map(&:abs).sum - radius
  end
end

class CliqueFinder
  def initialize(vertexes, neighbors)
    @vertexes, @neighbors = vertexes, neighbors
  end
  
  def cliques
    @cliques = []
    find_cliques(Set[], @vertexes.to_set, Set[])
    @cliques
  end

  private

  def find_cliques(r, p, x)
    if p.empty? && x.empty?
      @cliques << r
    else
      u = (p | x).max_by { |v| n(v).size }
      (p - n(u)).each do |v|
        find_cliques(r | [v], p & n(v), x & n(v))
        p = p - [v]
        x = x | [v]
      end
    end
  end
  
  def n(v)
    @neighbors[v]
  end
end


nanobots = File.readlines("input/day_23").map.with_index do |line, index|
  *center, radius = /pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/.match(line)[1..4].map(&:to_i)
  NanoBot.new(index, center, radius)
end

largest_radius_bot = nanobots.max_by(&:radius)
close_bots = nanobots.count { |bot| bot.distance_from(largest_radius_bot) <= largest_radius_bot.radius }

puts "Part 1: #{close_bots}"

neighbors = Hash.new { |hash, key| hash[key] = [] }
nanobots.combination(2).select { |a, b| a.intersects_with(b) }.each do |a, b|
  neighbors[a.id] << b.id
  neighbors[b.id] << a.id
end

cliques = CliqueFinder.new(nanobots.map(&:id), neighbors).cliques
best_clique = cliques.max_by(&:size).map { |id| nanobots[id] }

distance = best_clique.map(&:shortest_distance).max
puts "Part 2: #{distance}"
