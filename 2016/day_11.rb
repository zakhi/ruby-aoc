require "set"
require_relative "../helpers/queue"

class State
  def initialize(floors, elevator)
    @floors, @elevator = floors, elevator
  end

  def target?
    @floors.size == 1
  end

  def valid?
    target? || @floors.all? do |floor|
      groups = floor.group_by(&:last).transform_values { |items| items.map(&:first) }
      microchip_types = groups[:microchip] || []
      microchip_types.all? { |material| groups[:generator].nil? || groups[:generator].include?(material) }
    end
  end

  def neighboring_states
    next_floors = [1, -1].map { |offset| @elevator + offset }.select { |floor| (0...@floors.size).include?(floor) }
    selected_items = (1..2).flat_map { |items| @floors[@elevator].to_a.combination(items).to_a }

    states = next_floors.product(selected_items).map do |new_elevator, items_in_elevator|
      new_floors = @floors.dup
      new_floors[@elevator] -= items_in_elevator
      new_floors[new_elevator] += items_in_elevator

      compact_new_floors = new_floors.drop_while(&:empty?)
      compact_new_elevator = new_elevator - (new_floors.count - compact_new_floors.count)

      State.new(compact_new_floors, compact_new_elevator)
    end

    states.uniq.select(&:valid?)
  end

  def identifier
    @identifier ||= calculate_identifier
  end

  def to_s
    identifier
  end

  private

  def calculate_identifier
    elements = @floors.flat_map { |items| items.sort.map(&:first) }.uniq
    coded_floors = @floors.map do |floor|
      floor.map { |item| "#{elements.index(item.first)}#{item.last == :microchip ? "m" : "g"}" }.sort.join(",")
    end

    "#{@elevator}-#{coded_floors.join("|")}"
  end
end

StateWithDistance = Struct.new(:state, :distance) do
  include Comparable

  def <=>(other)
    self.distance <=> other.distance
  end
end

def shortest_distance(floors)
  queue = MinimumQueue.new
  distances = Hash.new(1000)
  initial_state = State.new(floors, 0)

  queue << StateWithDistance.new(initial_state, 0)
  distances[initial_state.identifier] = 0
  visited = Set[]

  until queue.empty?
    state, distance = *queue.pop
    break distance if state.target?
    next unless visited.add?(state.identifier)

    state.neighboring_states.reject { |s| visited.include?(s.identifier) }.each do |neighbor|
      new_distance = distance + 1
      if distances[neighbor.identifier] > new_distance
        distances[neighbor.identifier] = new_distance
        queue << StateWithDistance.new(neighbor, new_distance)
      end
    end
  end
end

floors = File.readlines("input/day_11").take(4).map do |line|
  Set[].tap do |items|
    items.merge(line.scan(/a (\w+) generator/).map { |match| [match.first.to_sym, :generator] })
    items.merge(line.scan(/a (\w+)-compatible microchip/).map { |match| [match.first.to_sym, :microchip] })
  end
end

puts "Part 1: #{shortest_distance(floors)}"

real_floors = floors.dup
real_floors[0].merge([[:elerium, :generator], [:elerium, :microchip], [:dilithium, :generator], [:dilithium, :microchip]])

puts "Part 2: #{shortest_distance(real_floors)}"
