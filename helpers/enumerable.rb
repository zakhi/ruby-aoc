module Enumerable
  def tally
    group_by(&:itself).transform_values(&:count)
  end
end

NaturalNumbers = Enumerator.new do |y|
  current = 1
  loop do
    y << current
    current += 1
  end
end
