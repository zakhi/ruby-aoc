def distance(x, y)
  (x.abs + y.abs) / 2
end

steps = File.read("input/day_11").chomp.split(",")

x = 0
y = 0
largest_distance = 0

steps.each do |step|
  case step
  when "n" then y += 2
  when "s" then y -= 2
  when "ne"
    y += 1
    x += 1
  when "nw"
    y += 1
    x -= 1
  when "se"
    y -= 1
    x += 1
  when "sw"
    y -= 1
    x -= 1
  end

  largest_distance = [largest_distance, distance(x, y)].max
end

puts "Part 1: #{distance(x, y)}"
puts "Part 2: #{largest_distance}"
