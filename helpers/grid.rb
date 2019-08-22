Point = Struct.new(:x, :y) do
  def to_s
    "<#{x}, #{y}>"
  end

  def distance_to(other)
    (self.x - other.x).abs + (self.y - other.y).abs
  end
end

class Grid
  include Enumerable

  def initialize(x_range, y_range)
    @xs, @ys = x_range, y_range
  end

  def each(&block)
    @xs.each do |x|
      @ys.map { |y| Point.new(x, y) }.each(&block)
    end
  end
end
