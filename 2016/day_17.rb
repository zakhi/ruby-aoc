require "digest"

class Step
  OFFSETS = { "U" => [0, -1], "D" => [0, 1], "L" => [-1, 0], "R" => [1, 0] }

  attr_reader :path

  def initialize(position:, path:)
    @position, @path = position, path
  end

  def target?
    @position == [4, 4]
  end

  def next_steps
    hash = Digest::MD5.hexdigest("#{INPUT}#{@path}")[0, 4].chars
    open_doors = hash.zip(OFFSETS.keys).select { |c, _| ("b".."f").include?(c) }.map(&:last)
    open_doors.map { |d| next_step(d) }.compact
  end

  def next_step(direction)
    next_position = @position.zip(OFFSETS[direction]).map(&:sum)
    return nil unless next_position.all? { |x| (1..4).include?(x) }
    Step.new(position: next_position, path: @path + direction)
  end
end

INPUT = "veumntbg"

def all_paths
  Enumerator.new do |y|
    steps = [Step.new(position: [1, 1], path: "")]

    until steps.empty?
      step = steps.shift
      if step.target?
        y << step.path
      else
        steps.push(*step.next_steps)
      end
    end
  end
end

shortest_path = all_paths.first
puts "Part 1: #{shortest_path}"

longest_path = all_paths.to_a.last
puts "Part 2: #{longest_path.length}"
