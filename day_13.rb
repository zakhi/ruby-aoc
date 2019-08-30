Location = Struct.new(:x, :y) do
  def to_s
    "#{x},#{y}"
  end

  def <=>(other)
    [y, x] <=> [other.y, other.x]
  end
end

class Cart
  attr_reader :location

  def initialize(location, direction)
    @location = location
    @direction = direction
    @turning = [:left, :straight, :right].cycle
  end

  def move(track)
    case @direction
    when :up then @location.y -= 1
    when :right then @location.x += 1
    when :down then @location.y += 1
    when :left then @location.x -= 1
    end

    case track[@location]
    when "/"
      case @direction
      when :right, :left then turn_left
      when :up, :down then turn_right
      end
    when "\\"
      case @direction
      when :right, :left then turn_right
      when :up, :down then turn_left
      end
    when "+"
      case @turning.next
      when :right then turn_right
      when :left then turn_left
      end
    end
  end

  def turn_left
    @direction = directions[(directions.find_index(@direction) - 1) % directions.size]
  end

  def turn_right
    @direction = directions[(directions.find_index(@direction) + 1) % directions.size]
  end

  def directions
    Directions.values
  end
end

class Tracks
  attr_reader :crashed

  def initialize(track, carts)
    @track = track
    @carts = carts
    @crashed = []
  end

  def drive
    while running_carts.size > 1
      for cart in @carts.sort_by(&:location)
        next if @crashed.include?(cart)
        cart.move(self)
        crashed_into_cart = running_carts.reject { |c| c == cart }.find { |c| c.location == cart.location }

        if crashed_into_cart
          @crashed << cart << crashed_into_cart
        end
      end
    end
  end
  
  def [](location)
    @track[location.y][location.x]
  end

  def running_carts
    @carts.reject { |cart| @crashed.include? cart }
  end
end

Directions = {
  "^" => :up,
  ">" => :right,
  "v" => :down,
  "<" => :left
}

carts = []

track = File.readlines("input/day_13").each_with_index.map do |line, index|
  line.to_enum(:scan, /[<>^v]/).map { Regexp.last_match }.each do |match|
    carts << Cart.new(Location.new(match.begin(0), index), Directions[match.to_s])
  end
  line.gsub(/[<>]/, "-").gsub(/[v^]/, "|")
end

tracks = Tracks.new(track, carts)
tracks.drive

puts "Part 1: #{tracks.crashed.first.location}"
puts "Part 2: #{tracks.running_carts.first.location}"
