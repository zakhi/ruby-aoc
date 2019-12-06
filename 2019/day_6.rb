require "set"

class OrbitMap
  def initialize(orbits)
    @orbited_by = orbits.map(&:reverse).to_h
    @orbit_counts = { "COM" => 0 }
  end

  def total_orbits
    @orbited_by.keys.sum { |object| orbit_count(object) }
  end

  def distance(source, target)
    closest_both_orbiting = (orbiting(source) & orbiting(target)).max_by { |object| orbit_count(object) }
    orbit_count(source) + orbit_count(target) - 2 * orbit_count(closest_both_orbiting) - 2
  end

  def orbit_count(object)
    @orbit_counts[object] ||= (1 + orbit_count(@orbited_by[object]))
  end

  def orbiting(object)
    orbited = @orbited_by[object] or return Set[]
    Set[orbited] + orbiting(orbited)
  end
end

orbits = File.readlines("input/day_6").map do |line|
  /(\w+)\)(\w+)/.match(line)[1..2]
end

orbit_map = OrbitMap.new(orbits)

puts "Part 1: #{orbit_map.total_orbits}"
puts "Part 2: #{orbit_map.distance("YOU", "SAN")}"
