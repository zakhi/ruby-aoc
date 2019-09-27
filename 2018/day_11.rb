GRID_SIZE = 300

class FuelGrid
  def initialize
    @grid = Array.new(GRID_SIZE) { |x| Array.new(GRID_SIZE) { |y| power_level(x + 1, y + 1) } }
    @sum_grid = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) }
    fill_sum_grid
  end

  def squares(square_size)
    Enumerator.new do |yielder|
      squares_on_side = GRID_SIZE - square_size + 1
      (1..squares_on_side).each do |x|
        (1..squares_on_side).each { |y| yielder << [x, y] }
      end
    end
  end

  def all_squares
    Enumerator.new do |yielder|
      (1..GRID_SIZE).each do |size|
        squares(size).each { |square| yielder << [square, size].flatten }
      end
    end
  end

  def square_fuel(x, y, size)
    x1 = x - 1
    y1 = y - 1
    x2 = x1 + size - 1
    y2 = y1 + size - 1
    fuel = @sum_grid[x2][y2]
    fuel -= @sum_grid[x1 - 1][y2] if x1 > 0
    fuel -= @sum_grid[x2][y1 - 1] if y1 > 0
    fuel += @sum_grid[x1 - 1][y1 - 1] if (x1 > 0) && (y1 > 0)
    fuel
  end

  private def power_level(x, y, serial_number=7315)
    rack_id = x + 10
    power_level = (rack_id * y + serial_number) * rack_id
    power_level / 100 % 10 - 5
  end

  private def fill_sum_grid
    GRID_SIZE.times do |x|
      GRID_SIZE.times do |y|
        @sum_grid[x][y] = @grid[x][y]
        @sum_grid[x][y] += @sum_grid[x - 1][y] if x > 0
        @sum_grid[x][y] += @sum_grid[x][y - 1] if y > 0
        @sum_grid[x][y] -= @sum_grid[x - 1][y - 1] if (x > 0) && (y > 0)
      end
    end
  end
end

grid = FuelGrid.new

largest_3_square = grid.squares(3).max_by { |x, y| grid.square_fuel(x, y, 3) }
puts "Part 1: #{largest_3_square}"

largest_square = grid.all_squares.max_by { |x, y, size| grid.square_fuel(x, y, size) }
puts "Part 2: #{largest_square}"
