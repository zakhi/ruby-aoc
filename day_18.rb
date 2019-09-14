require "set"

class Field
  def initialize(field)
    @field = field
  end

  def woods
    @field.values.count { |s| s == "|" }
  end

  def lumberyards
    @field.values.count { |s| s == "#" }
  end

  def all_squares
    @field.sort.map(&:last)
  end

  def progress
    Enumerator.new do |yielder|
      current_field = self
      loop do
        new_field = current_field.transform
        yielder << new_field
        current_field = new_field
      end
    end
  end

  def transform
    result_field = @field.to_h do |position, type|
      adjacents = adjacents_of(position).map { |s| @field[s] }.compact
      new_type = case type
      when "." then adjacents.count { |s| s == "|" } >= 3 ? "|": "."
      when "|" then adjacents.count { |s| s == "#" } >= 3 ? "#" : "|"
      when "#" then adjacents.any? { |s| s == "#" } && adjacents.any? { |s| s == "|" } ? "#" : "."
      end
      [position, new_type]
    end
    Field.new(result_field)  
  end

  def adjacents_of(square)
    indices = [-1, 0, 1]
    indices.product(indices).reject { |s| s == [0, 0] }.map do |s| 
      [square.first + s.first, square.last + s.last ] 
    end
  end

  def display
    max = @field.keys.max
    (0..max.first).each do |y|
      puts (0..max.last).map { |x| @field[[y, x]] }.join
    end
  end
end

initial_field = {}

File.readlines("input/day_18").each_with_index do |line, y|
  line.chomp.each_char.with_index do |char, x|
    initial_field[[y, x]] = char
  end
end

field = Field.new(initial_field)
field_after_10_minutes = field.progress.take(10).last

puts "Part 1: #{field_after_10_minutes.woods * field_after_10_minutes.lumberyards}"

previous_fields = { field.all_squares => [0, field] }

repeating_index, previous_index, repeating_field = field.progress.each_with_index do |next_field, i|
  previous_field = previous_fields[next_field.all_squares]
  break [i + 1, *previous_field] if previous_field
  previous_fields[next_field.all_squares] = [i + 1, next_field]
end

gap = repeating_index - previous_index
target = 1000000000

remainder = (target - previous_index) % gap
target_field = previous_fields.values.find { |index, *| index == previous_index + remainder }.last

puts "Part 2: #{target_field.woods * target_field.lumberyards}"
