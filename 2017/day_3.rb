INPUT = 312051

end_index = 1

edge_of_input = 1.step(by: 2).find do |edge|
  end_index += (edge - 1) * 4
  end_index > INPUT
end

position_in_edge = (INPUT - 1) % (edge_of_input - 1)
distance_from_edge_center = (position_in_edge - edge_of_input / 2).abs
total_distance = distance_from_edge_center + edge_of_input / 2

puts "Part 1: #{total_distance}"

class Array
  alias :x :first
  alias :y :last

  def neighbors
    points = [1, 0, -1].product([1, -1])
    (points + points.map(&:reverse)).uniq.map { |offset| zip(offset).map(&:sum) }
  end
end

class Spiral
  def positions
    Enumerator.new do |y|
      3.step(by: 2).each do |edge|
        size = edge / 2
        range = -size..size
        side_squares = range.to_a.product([range.begin, range.end])
        squares = (side_squares + side_squares.map(&:reverse)).uniq
        squares.sort! { |a, b| compare(a, b, size) }
        squares.drop(1).each { |s| y << s }
        y << squares.first
      end
    end
  end

  def compare(a, b, size)
    edge_compare = edge_on(a, size) <=> edge_on(b, size)

    if edge_compare != 0
      edge_compare
    elsif a.x == b.x
      a.x > 0 ? a.y <=> b.y : b.y <=> a.y
    else
      a.y > 0 ? b.x <=> a.x : a.x <=> b.x
    end
  end

  def edge_on(square, size)
    case
    when square.x == size then 0
    when square.y == size then 1
    when square.x == -size then 2
    when square.y == -size then 3
    end
  end
end

values = Hash.new(0)
values[[0, 0]] = 1

larger_value = Spiral.new.positions.each do |position|
  new_value = position.neighbors.sum { |neighbor| values[neighbor] }
  break new_value if new_value > INPUT
  values[position] = new_value
end

puts "Part 2: #{larger_value}"
