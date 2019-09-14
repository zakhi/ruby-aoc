require "set"

class Array
  alias_method :y, :first
  alias_method :x, :last
end

class Land
  def initialize(blocks)
    @blocks = blocks.to_set
    @waters = Set[]
    @min_y, @max_y = @blocks.map(&:y).minmax
  end

  def scan
    until flow_downwards([0, 500])
    end
  end

  def total_water_tiles
    @waters.count
  end

  def water_retained
    @waters.count { |tile| @blocks.include? tile }
  end

  def flow_downwards(start)
    current = start

    while current.y < @max_y
      target = tile_below(current)
      return flow_sideways(current) if blocked?(target)
      @waters << target if target.y >= @min_y
      current = target
    end
    true
  end

  def flow_sideways(start)
    right_reached_end, right_blocked_tiles = flow_one_side(start, :right) 
    left_reached_end, left_blocked_tiles = flow_one_side(start, :left) 

    if right_blocked_tiles and left_blocked_tiles
      @blocks.merge(right_blocked_tiles + left_blocked_tiles)
      return false
    end

    right_reached_end and left_reached_end
  end

  def flow_one_side(start, direction)
    current = start

    while blocked?(tile_below(current))
      target = [current.y, current.x + (direction == :right ? 1 : -1)]
      if blocked?(target)
        blocked_range = Range.new(*[start.x, current.x].minmax)
        return [true, blocked_range.map { |x| [start.y, x] }]
      else
        @waters << target
        current = target
      end
    end
    flow_downwards(current)
  end

  def tile_below(tile)
    [tile.y + 1, tile.x]
  end

  def blocked?(tile)
    @blocks.include?(tile)
  end

  def display
    y_range = Range.new(*@blocks.map(&:y).minmax)
    x_range = Range.new(*@blocks.map(&:x).minmax)

    y_range.each do |y|
      row = x_range.map do |x|
        if @blocks.include?([y, x])
          @waters.include?([y, x]) ? "~" : "#"
        elsif @waters.include?([y, x])
          "|"
        else
          "."
        end
      end
      puts row.join
    end
  end
end

blocks = File.readlines("input/day_17").flat_map do |line|
  match = /(x|y)=(\d+), (x|y)=(\d+\.\.\d+)/.match(line)
  axis = match[1]
  fixed = match[2].to_i
  range = eval(match[4])

  case axis
  when "x" then range.map { |y| [y, fixed] }
  when "y" then range.map { |x| [fixed, x] }
  end
end

land = Land.new(blocks)
land.scan

puts "Part 1: #{land.total_water_tiles}"
puts "Part 2: #{land.water_retained}"
