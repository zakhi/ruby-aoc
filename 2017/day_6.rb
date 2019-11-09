require "set"

class MemoryBank
  def reallocate(initial_state)
    history = Set[initial_state]
    state = initial_state.clone

    1.step do |cycle|
      max = state.max
      max_index = state.index(max)
      state[max_index] = 0
      (1..max).each { |i| state[(max_index + i) % state.size] += 1 }

      break cycle, state unless history.add?(state.clone)
    end
  end
end

initial_blocks = File.read("input/day_6").scan(/\d+/).map(&:to_i)
memory_bank = MemoryBank.new

cycles, repeating_state = memory_bank.reallocate(initial_blocks)
puts "Part 1: #{cycles}"

repeating_cycles, * = memory_bank.reallocate(repeating_state)
puts "Part 2: #{repeating_cycles}"
