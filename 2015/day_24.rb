def smallest_group_in_equal_division(packages, number_of_groups:)
  Enumerator.new do |y|
    if number_of_groups == 1
      y << packages
    else
      desired_weight = packages.sum / number_of_groups
      max_group_size = packages.count / number_of_groups

      (1..max_group_size).each do |group_size|
        candidates = packages.combination(group_size).lazy.select { |group| group.sum == desired_weight }

        candidates.each do |group|
          packages_left = packages - group
          if smallest_group_in_equal_division(packages_left, number_of_groups: number_of_groups - 1).any?
            y << group
          end
        end
      end
    end
  end
end

def smallest_entanglement(groups)
  minimal_size = groups.first.size
  entanglements = groups.lazy.uniq.take_while { |group| group.size == minimal_size }.map do |group|
    group.inject(&:*)
  end

  entanglements.min
end

packages = File.readlines("input/day_24").map { |line| line.chomp.to_i }

puts "Part 1: #{smallest_entanglement(smallest_group_in_equal_division(packages, number_of_groups: 3))}"
puts "Part 2: #{smallest_entanglement(smallest_group_in_equal_division(packages, number_of_groups: 4))}"
