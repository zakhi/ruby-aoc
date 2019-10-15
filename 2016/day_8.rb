class Screen
  ROWS = 6
  COLUMNS = 50

  def initialize
    @screen = Array.new(ROWS) { Array.new(COLUMNS, false) }
  end

  def count
    @screen.sum { |row| row.count(&:itself) }
  end

  def run(instruction)
    case instruction
    when /rect (\d+)x(\d+)/ then rect(*params(Regexp.last_match))
    when /rotate row y=(\d+) by (\d+)/ then rotate_row(*params(Regexp.last_match))
    when /rotate column x=(\d+) by (\d+)/ then rotate_column(*params(Regexp.last_match))
    end
  end

  def print
    @screen.each do |row|
      puts row.map { |light| light ? "#" : " " }.join
    end
  end

  private

  def params(match)
    match[1..2].map(&:to_i)
  end

  def rect(columns, rows)
    columns.times do |column|
      rows.times do |row|
        @screen[row][column] = true
      end
    end
  end

  def rotate_row(row, offset)
    lit_indices = rotate_lit_indices(@screen[row], offset)

    COLUMNS.times do |column|
      @screen[row][column] = lit_indices.include?(column)
    end
  end

  def rotate_column(column, offset)
    lit_indices = rotate_lit_indices(@screen.transpose[column], offset)

    ROWS.times do |row|
      @screen[row][column] = lit_indices.include?(row)
    end
  end

  def rotate_lit_indices(axis, offset)
    lit_indices = axis.each_with_index.select { |lit, _| lit }.map(&:last)
    lit_indices.map! { |i| (i + offset) % axis.size }
  end
end

instructions = File.readlines("input/day_8")

screen = Screen.new
instructions.each { |instruction| screen.run(instruction) }

puts "Part 1: #{screen.count}"
puts "Part 2:"
screen.print
