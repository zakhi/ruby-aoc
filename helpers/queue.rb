require "set"

class MinimumQueue
  def initialize
    @elements = [nil]
  end

  def push(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  alias :<< :push

  def size
    @elements.size - 1
  end

  def pop
    exchange(1, @elements.size - 1)
    @elements.pop.tap { bubble_down(1) }
  end

  def empty?
    @elements.size == 1
  end

  private

  def bubble_up(index)
    parent_index = index / 2
    return if index <= 1 || @elements[parent_index] <= @elements[index]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = index * 2
    return if child_index > @elements.size - 1

    left = @elements[child_index]
    right = @elements[child_index + 1]
    child_index += 1 if child_index < @elements.size - 1 && right < left

    return if @elements[index] <= @elements[child_index]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end
