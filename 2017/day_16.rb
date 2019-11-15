class Dance
  def initialize
    @programs = ("a".."p").to_a
  end

  def perform(moves)
    moves.each do |move|
      case move
      when /s(\d+)/ then spin(Regexp.last_match[1].to_i)
      when %r{x(\d+)/(\d+)} then exchange(*Regexp.last_match[1..2].map(&:to_i))
      when %r{p(\w)/(\w)} then partner(*Regexp.last_match[1..2])
      end
    end
  end

  def positions
    @programs.join
  end

  private

  def spin(count)
    @programs.rotate!(-count)
  end

  def exchange(i, j)
    @programs[i], @programs[j] = @programs[j], @programs[i]
  end

  def partner(a, b)
    exchange(@programs.index(a), @programs.index(b))
  end
end

moves = File.read("input/day_16").chomp.split(",")
dance = Dance.new
dance.perform(moves)

puts "Part 1: #{dance.positions}"

visited = { dance.positions => 1 }

repeating, repeated = (2..1_000_000_000).each do |i|
  dance.perform(moves)

  break [i, visited[dance.positions]] if visited.include?(dance.positions)
  visited[dance.positions] = i
end

offset = (1_000_000_000 - repeated + 1) % (repeating - repeated)

long_dance = Dance.new
offset.times { long_dance.perform(moves) }

puts "Part 2: #{long_dance.positions}"
