def move(location, dx: 0, dy: 0)
  [location.first + dx, location.last + dy]
end

def find_code(instructions, keypad)
  locations = instructions.each_with_object([keypad.key(5)]) do |sequence, locations|
    locations << sequence.inject(locations.last) do |location, direction|
      new_location = case direction
        when :up then move(location, dy: 1)
        when :down then move(location, dy: -1)
        when :left then move(location, dx: -1)
        when :right then move(location, dx: 1)
      end
      keypad.include?(new_location) ? new_location : location
    end
  end

  locations.drop(1).map { |location| keypad[location] }.join
end


instructions = File.readlines("input/day_2").map do |line|
  line.each_char.map do |char|
    case char
      when "R" then :right
      when "L" then :left
      when "U" then :up
      when "D" then :down
    end
  end
end

simple_keypad = {
  [-1, 1]  => 1, [0, 1]  => 2, [1, 1]  => 3,
  [-1, 0]  => 4, [0, 0]  => 5, [1, 0]  => 6,
  [-1, -1] => 7, [0, -1] => 8, [1, -1] => 9
}

puts "Part 1: #{find_code(instructions, simple_keypad)}"

advanced_keypad = {
                                 [0, 2]  => 1,
                [-1, 1]  => 2,   [0, 1]  => 3,   [1, 1]  => 4,
  [-2, 0] => 5, [-1, 0]  => 6,   [0, 0]  => 7,   [1, 0]  => 8,   [2, 0] => 9,
                [-1, -1] => "A", [0, -1] => "B", [1, -1] => "C",
                                 [0, -2] => "D"
}

puts "Part 2: #{find_code(instructions, advanced_keypad)}"
