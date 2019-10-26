ranges = File.readlines("input/day_20").map do |line|
  start, finish = /(\d+)-(\d+)/.match(line)[1..2].map(&:to_i)
  (start..finish)
end

ranges.sort_by!(&:begin)
candidate = 0

first_non_blocked = ranges.each do |range|
  next if range.end < candidate
  break candidate unless range.include?(candidate)
  candidate = range.end + 1
end

puts "Part 1: #{first_non_blocked}"

total_non_blocked = 0
last_blocked = 0

ranges.each do |range|
  next if range.end < last_blocked
  total_non_blocked += range.begin - last_blocked - 1 if range.begin > last_blocked
  last_blocked = range.end
end

puts "Part 2: #{total_non_blocked}"
