require_relative("../helpers/enumerable")

class Guard
  attr_reader :id

  def initialize(id)
    @id = id
    @sleep_periods = []
  end

  def fall_asleep(minute)
    @sleep_start = minute
  end

  def wake_up(minute)
    @sleep_periods << (@sleep_start...minute)
  end

  def sleeper?
    !@sleep_periods.empty?
  end

  def total_min_sleep
    @sleep_periods.map(&:size).sum
  end

  def minute_most_frequent_asleep
    minute_counts = @sleep_periods.flat_map(&:to_a).tally
    minute_counts.max_by(&:last)
  end
end

lines = File.readlines("input/day_4").sort!

guards = Hash.new { |hash, id| hash[id] = Guard.new(id) }
current_guard = nil

lines.each do |line|
  case line
  when /Guard #(\d+) begins shift/
    current_guard = guards[$1.to_i]
  when /:(\d{2})\] falls asleep/
    current_guard.fall_asleep($1.to_i)
  when /:(\d{2})\] wakes up/
    current_guard.wake_up($1.to_i)
  end
end

most_sleeper = guards.values.max_by(&:total_min_sleep)
puts "Part 1: #{most_sleeper.id * most_sleeper.minute_most_frequent_asleep.first}"

most_consistent_sleeper = guards.values.select(&:sleeper?).max_by { |guard| guard.minute_most_frequent_asleep.last }
puts "Part 2: #{most_consistent_sleeper.id * most_consistent_sleeper.minute_most_frequent_asleep.first}"
