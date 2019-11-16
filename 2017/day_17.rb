INPUT = 312

last_position = 0

spinlock = (1..2017).each_with_object([0]) do |i, spinlock|
  last_position = (last_position + INPUT) % i + 1
  spinlock.insert(last_position, i)
end

following_2017 = spinlock[spinlock.index(2017) + 1]
puts "Part 1: #{following_2017}"

last_position = 0
following_zero = nil

(1..50_000_000).each do |i|
  last_position = (last_position + INPUT) % i + 1
  following_zero = i if last_position == 1
end

puts "Part 2: #{following_zero}"
