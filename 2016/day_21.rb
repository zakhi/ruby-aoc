Operation = Struct.new(:function, :arguments)

class Scrambler
  def initialize(operations)
    @operations = operations
  end

  def scramble(password)
    result = @operations.each_with_object(password.chars) do |operation, string|
      send(operation.function, string, *operation.arguments)
    end
    result.join
  end

  def unscramble(password)
    result = @operations.reverse_each.with_object(password.chars) do |operation, string|
      case operation.function
      when :rotate_left then rotate_right(string, *operation.arguments)
      when :rotate_right then rotate_left(string, *operation.arguments)
      when :rotate_position then rotate_position(string, *operation.arguments, right: false)
      when :move then move(string, *operation.arguments.reverse)
      else send(operation.function, string, *operation.arguments)
      end
    end
    result.join
  end

  def swap_positions(pass, x, y)
    pass[x], pass[y] = pass[y], pass[x]
  end

  def swap_letters(pass, x, y)
    ix = pass.index(x)
    iy = pass.index(y)
    pass[ix], pass[iy] = pass[iy], pass[ix]
  end

  def rotate_left(pass, x)
    pass.rotate!(x)
  end

  def rotate_right(pass, x)
    pass.rotate!(-x)
  end

  def rotate_position(pass, x, right: true)
    ix = pass.index(x)
    rotation = if right
      -(ix + 1 + (ix >= 4 ? 1 : 0))
    else
      case ix
      when 0 then 1
      when proc(&:odd?) then ix / 2 + 1
      else  (ix / 2) - 2 + pass.length - 1
      end
    end

    pass.rotate!(rotation)
  end

  def reverse_positions(pass, x, y)
    pass[x..y] = pass[x..y].reverse
  end

  def move(pass, x, y)
    pass.insert(y, pass.delete_at(x))
  end
end

operations = File.readlines("input/day_21").map do |line|
  case line
  when /swap position (\d+) with position (\d+)/ then Operation.new(:swap_positions, $~[1..2].map(&:to_i))
  when /swap letter (\w) with letter (\w)/ then Operation.new(:swap_letters, $~[1..2])
  when /rotate left (\d+) steps?/ then Operation.new(:rotate_left, [$1.to_i])
  when /rotate right (\d+) steps?/ then Operation.new(:rotate_right, [$1.to_i])
  when /rotate based on position of letter (\w)/ then Operation.new(:rotate_position, [$1])
  when /reverse positions (\d+) through (\d+)/ then Operation.new(:reverse_positions, $~[1..2].map(&:to_i))
  when /move position (\d+) to position (\d+)/ then Operation.new(:move, $~[1..2].map(&:to_i))
  end
end

scrambler = Scrambler.new(operations)

puts "Part 1: #{scrambler.scramble("abcdefgh")}"
puts "Part 2: #{scrambler.unscramble("fbgdceah")}"
