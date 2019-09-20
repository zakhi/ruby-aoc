module Enumerable
  def tally
    group_by(&:itself).transform_values(&:count)
  end
end
