changes = File.read("input/day_1").chomp.each_char.map do |c|
  case c
  when "(" then 1
  when ")" then -1
  end
end

puts "Part 1: #{changes.sum}"

position = changes.each_with_index.inject(0) do |floor, (change, index)|
  new_floor = floor + change
  break index + 1 if new_floor == -1
  new_floor
end

puts "Part 2: #{position}"
