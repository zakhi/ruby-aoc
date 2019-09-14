class Polymer
  def initialize(chars)
    @chars = chars
  end

  def react(ignore_unit=nil)
    reacted_polymer = []

    for unit in @chars
      next if unit.downcase == ignore_unit
      
      if reacted_polymer.empty? or !react_with(unit, reacted_polymer.last)
        reacted_polymer << unit
      else
        reacted_polymer.pop
      end
    end
    
    reacted_polymer.length
  end

  def react_with(first, second)
    first != second and first.downcase == second.downcase
  end
end

polymer = Polymer.new(File.read("input/day_5").chomp.chars)
puts "Part 1: #{polymer.react}"

minimal_polymer = ("a".."z").map { |ignore_unit| polymer.react(ignore_unit) }.min
puts "Part 2: #{minimal_polymer}"
