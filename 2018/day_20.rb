class Array
  alias_method :x, :first
  alias_method :y, :last
end

class ProjectArea
  def initialize(steps)
    @steps = steps.chars.lazy
    @offsets = { n: [0, 1], s: [0, -1], e: [1, 0], w: [-1, 0] }
    @trails = [[0, 0]]
    @distances = { [0, 0] => 0 }
  end

  def furthest_room_distance
    @distances.values.max
  end

  def rooms_further_than(distance)
    @distances.values.count { |d| d >= distance }
  end

  def scan
    loop do
      step = @steps.next
      case step
      when "^" then next
      when /N|W|S|E/ then visit(step, @trails)
      when "(" then @trails.push(*scan_group(@trails))
      when "$" then break
      end
    end
  end

  def scan_group(trails)
    starts = trails.clone
    new_trails = []
    current_trails = trails
    loop do
      step = @steps.next
      case step
      when /N|W|S|E/ then visit(step, current_trails)
      when "(" then new_trails.push(*scan_group(current_trails))
      when ")" then break
      when "|" 
        current_trails = starts.clone
        new_trails.push(*current_trails)
      end
    end
    new_trails
  end

  def visit(direction, trails)
    offset = @offsets[direction.downcase.to_sym]
    trails.map! do |room|
      [room.x + offset.x, room.y + offset.y].tap do |new_room|
        @distances[new_room] = @distances[room] + 1 unless @distances[new_room]
      end
    end
  end
end

steps = File.read("input/day_20")
area = ProjectArea.new(steps)
area.scan

puts "Part 1: #{area.furthest_room_distance}"
puts "Part 2: #{area.rooms_further_than(1000)}"
