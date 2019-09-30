class Reindeer
  def initialize(name, speed, fly_time, rest_time)
    @name, @speed, @fly_time, @rest_time = name, speed, fly_time, rest_time
  end

  def distance_after(seconds)
    full_periods = seconds / (@fly_time + @rest_time)
    remainder = [@fly_time, seconds % (@fly_time + @rest_time)].min
    @speed * (full_periods * @fly_time + remainder)
  end
end

reindeer = File.readlines("input/day_14").map do |line|
  match = %r{(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}.match(line)
  Reindeer.new(match[1], *match[2..4].map(&:to_i))
end

distances = reindeer.map { |r| r.distance_after(2503) }
puts "Part 1: #{distances.max}"

scores = Hash.new(0)

(1..2503).each do |time|
  positions = reindeer.map { |r| [r, r.distance_after(time)] }.to_h
  lead_position = positions.values.max
  positions.select { |*, v| v == lead_position }.each_key { |leader| scores[leader] += 1 }
end

puts "Part 2: #{scores.values.max}"
