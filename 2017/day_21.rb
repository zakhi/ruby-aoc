class Grid
  def initialize(rows)
    @rows = rows
  end

  def pixels_on
    @rows.flatten.count("#")
  end

  def transform(rules)
    size = @rows.size % 2 == 0 ? 2 : 3
    row_squares = @rows.size / size

    new_rows = Array.new(row_squares * (size + 1)) { Array.new(row_squares * (size + 1)) }
    last_row = (row_squares - 1) * size

    0.step(by: size, to: last_row) do |y|
      0.step(by: size, to: last_row) do |x|
        square = @rows[y, size].map { |row| row[x, size] }
        rules[square].each_with_index do |row, dy|
          row.each_with_index do |char, dx|
            new_rows[y / size * (size + 1) + dy][x / size * (size + 1) + dx] = char
          end
        end
      end
    end

    Grid.new(new_rows)
  end
end


def symmetries_of(pattern)
  transposed = pattern.transpose

  [
    pattern, pattern.reverse, pattern.map(&:reverse), pattern.reverse.map(&:reverse),
    transposed, transposed.reverse, transposed.map(&:reverse), transposed.reverse.map(&:reverse)
  ].uniq
end

rules = File.readlines("input/day_21").each_with_object({}) do |line, rules|
  input, output = %r{([.#/]+) => ([.#/]+)}.match(line)[1..2].map { |x| x.split("/").map(&:chars) }
  symmetries_of(input).each { |pattern| rules[pattern] = output }
end

initial_grid = Grid.new([%w{ . # . }, %w{ . . # }, %w{ # # # }])

grid_after_5_iterations = 5.times.inject(initial_grid) { |grid| grid.transform(rules) }
puts "Part 1: #{grid_after_5_iterations.pixels_on}"

grid_after_18_iterations = 13.times.inject(grid_after_5_iterations) { |grid| grid.transform(rules) }
puts "Part 2: #{grid_after_18_iterations.pixels_on}"
