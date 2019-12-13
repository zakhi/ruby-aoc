require_relative "intcode"

class Arcade
  def initialize(program)
    @computer = IntCodeComputer.new(program)
    @computer.output = self
    @computer.input = self
    @tiles = {}
  end

  def block_count
    @tiles.count { |*, type| type == 2 }
  end

  def score
    @tiles[[-1, 0]]
  end

  def start
    @current_tile = []
    @computer.run
  end

  def <<(value)
    @current_tile << value
    if @current_tile.size == 3
      @tiles[@current_tile.take(2)] = @current_tile.last
      @current_tile = []
    end
  end

  def shift
    ball = @tiles.key(4).first
    paddle = @tiles.key(3).first
    ball <=> paddle
  end
end

source = File.read("input/day_13").chomp.split(",").map(&:to_i)
arcade = Arcade.new(source)
arcade.start

puts "Part 1: #{arcade.block_count}"

working_source = [2] + source.drop(1)
working_arcade = Arcade.new(working_source)
working_arcade.start

puts "Part 2: #{working_arcade.score}"
