class Tiles
  def initialize(first_row)
    @first_row = first_row
  end

  def safe_tiles_in_rows(count)
    last_row = nil

    count.times.inject(0) do |total_safe, _|
      last_row = build_row(last_row)
      total_safe + last_row.count(".")
    end
  end

  def build_row(previous)
    return @first_row unless previous

    [".", *previous, "."].each_cons(3).map do |tiles|
      tiles[0] == tiles[2] ? "." : "^"
    end
  end
end

first_row = File.read("input/day_18").chomp.chars
tiles = Tiles.new(first_row)

puts "Part 1: #{tiles.safe_tiles_in_rows(40)}"
puts "Part 1: #{tiles.safe_tiles_in_rows(400000)}"
