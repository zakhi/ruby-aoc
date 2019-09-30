require "json"

json = JSON.parse(File.read("input/day_12").chomp)

def collect_numbers(json, numbers = [], reject_word: nil)
  case json
  when Integer then numbers << json
  when Array then json.each { |element| collect_numbers(element, numbers, reject_word: reject_word) }
  when Hash
    if reject_word.nil? || (!json.has_key?(reject_word) && !json.has_value?(reject_word))
      json.values.each { |value| collect_numbers(value, numbers, reject_word: reject_word) }
    end
  end
  numbers
end

all_numbers = collect_numbers(json)
puts "Part 1: #{all_numbers.sum}"

filtered_numbers = collect_numbers(json, reject_word: "red")
puts "Part 2: #{filtered_numbers.sum}"
