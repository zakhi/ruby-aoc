require "set"

Action = Struct.new(:one, :move, :next_state)

class State
  def initialize(zero_action, one_action)
    @zero_action, @one_action = zero_action, one_action
  end

  def action(is_one)
    is_one ? @one_action : @zero_action
  end
end

def parse_action(text)
  one = /Write the value (\d)/.match(text)[1].to_i == 1
  move = /Move one slot to the (\w+)/.match(text)[1].to_sym
  next_state = /Continue with state (\w)/.match(text)[1]
  Action.new(one, move, next_state)
end

def parse_state(text)
  letter = /In state (\w):/.match(text)[1]
  lines = text.split("\n")
  zero_action = parse_action(lines[2..4].join(" "))
  one_action = parse_action(lines[6..8].join(" "))
  [letter, State.new(zero_action, one_action)]
end

parts = File.read("input/day_25").split("\n\n")
start = /Begin in state (\w)/.match(parts.first)[1]
steps = /Perform a diagnostic checksum after (\d+) steps/.match(parts.first)[1].to_i

states = parts.drop(1).map { |part| parse_state(part) }.to_h

ones = Set[]
index = 0
current_state = start

steps.times do
  action = states[current_state].action(ones.include?(index))
  action.one ? ones << index : ones.delete(index)
  index += action.move == :right ? 1 : -1
  current_state = action.next_state
end

puts "Part 1: #{ones.size}"
