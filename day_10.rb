require_relative "helpers/enumerable"

Point = Struct.new(:x, :y, :vx, :vy) do
  def position_after(seconds)
    [x + seconds * vx, y + seconds * vy]
  end
end

points = File.readlines("input/day_10").map do |line|
  match = /<\s?(-?\d+), \s?(-?\d+)> .*<\s?(-?\d+), \s?(-?\d+)>/.match(line)
  Point.new(*match[1..4].map(&:to_i))
end

def total_distance(points, time=0)
  min_x, max_x = points.map { |p| p.position_after(time).first }.minmax
  max_x - min_x
end

def print(points, time)
  positions = points.map { |p| p.position_after(time) }
  xs = Range.new(*positions.map(&:first).minmax)
  ys = Range.new(*positions.map(&:last).minmax)

  for y in ys
    puts xs.map { |x| positions.include?([x, y]) ? "#" : " " }.join
  end
  puts
end

previous_distance = total_distance(points)

message_time = 1.step do |time|
  distance = total_distance(points, time)
  break time - 1 if distance > previous_distance
  previous_distance = distance
end

puts "Part 1:"
print(points, message_time)

puts "Part 2: #{message_time}"
