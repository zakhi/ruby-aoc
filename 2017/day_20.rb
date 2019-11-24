require "set"

class Point
  attr_reader :id, :position, :velocity, :acceleration

  def initialize(id, position, velocity, acceleration)
    @id, @position, @velocity, @acceleration = id, position, velocity, acceleration
  end

  def distance_at(time)
    by_coordinate.map do |position, velocity, acceleration|
      position + time * (2 * velocity + (time + 1) * acceleration) / 2
    end.map(&:abs).sum
  end

  def first_collision_time(other)
    times = by_coordinate.zip(other.by_coordinate).map do |first, second|
      # ∆at² + (2∆v + ∆a)t + 2∆p = 0
      dp, dv, da = first.zip(second).map { |a, b| a - b }.map(&:to_f)

      if da == 0
        dv == 0 ? valid_times : valid_times(-dp / dv)
      else
        disc = (2 * dv + da) ** 2 - 8 * da * dp

        if disc.negative?
          valid_times
        else
          first_solution = (- (2 * dv + da) - Math.sqrt(disc)) / (2 * da)
          second_solution = (- (2 * dv + da) + Math.sqrt(disc)) / (2 * da)
          valid_times(first_solution, second_solution)
        end
      end
    end

    times.inject(&:&).first
  end

  def by_coordinate
    [@position, @velocity, @acceleration].transpose
  end

  def valid_times(*times)
    times.compact.select { |t| t == t.to_i && t.positive? }.map(&:to_i).to_set
  end
end


points = File.readlines("input/day_20").map.with_index do |line, id|
  match = /p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/.match(line)
  Point.new(id, *match[1..9].map(&:to_i).each_slice(3))
end

closest_point = points.min_by { |p| p.distance_at(1_000_000) }
puts "Part 1: #{closest_point.id}"

collision_times = points.combination(2).map { |p1, p2| [p1.first_collision_time(p2), [p1, p2]] }
  .reject { |time, *| time.nil? }
  .group_by(&:first)
  .transform_values { |ps| ps.flat_map(&:last).to_set }

points_left = points.to_set

collision_times.sort_by(&:first).each do |*, ps|
  ps.each { |p| points_left.delete(p) }
end

puts "Part 2: #{points_left.size}"
