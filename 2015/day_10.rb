INPUT = "1113122113"

def look_and_say(times, start: INPUT)
  times.times.inject(start) do |string|
    string.scan(/((\d)\2*)/).flat_map { |pattern, digit| [pattern.length, digit] }.join
  end
end

result_after_40 = look_and_say(40)
puts "Part 1: #{result_after_40.length}"

result_after_50 = look_and_say(10, start: result_after_40)
puts "Part 2: #{result_after_50.length}"
