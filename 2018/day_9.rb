class Marble
  attr_reader :value
  attr_accessor :next, :previous

  def initialize(value)
    @value = value
    @next = self
    @previous = self
  end
  
  def clockwise(count=1)
    count.times.inject(self) { |node| node.next }
  end

  def counter_clockwise(count=1)
    count.times.inject(self) { |node| node.previous }
  end

  def insert_after(node)
    self.next = node.next
    self.previous = node
    self.next.previous = self.previous.next = self
  end

  def remove
    self.next.previous = self.previous
    self.previous.next = self.next
    self.previous = self.next = self
  end
end


class Game
  def initialize(players)
    @players = players
  end

  def play(marbles)
    @scores = (1..@players).map { |i| [i, 0] }.to_h
    current_marble = Marble.new(0)

    (1..marbles).lazy.map { |value| Marble.new(value) }.zip((1..@players).cycle).each do |marble, player|
      if marble.value % 23 == 0
        marble_to_remove = current_marble.counter_clockwise(7)
        current_marble = marble_to_remove.clockwise
        @scores[player] += marble.value + marble_to_remove.remove.value
      else
        current_marble = marble.insert_after(current_marble.clockwise)
      end
    end
  end

  def best_score
    @scores.values.max
  end
end

players, marbles = /(\d+) players; last marble is worth (\d+) points/.match(File.read("input/day_9"))[1..2].map(&:to_i)

game = Game.new(players)
game.play(marbles)

puts "Part 1: #{game.best_score}"

game.play(marbles * 100)
puts "Part 2: #{game.best_score}"
