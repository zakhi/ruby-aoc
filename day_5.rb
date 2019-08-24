class String
  def react(ignore_unit=nil)
    reacted_polymer = []

    for unit in chars
      next if unit.downcase == ignore_unit
      
      if reacted_polymer.empty? or !unit.reacts_with(reacted_polymer.last)
        reacted_polymer << unit
      else
        reacted_polymer.pop
      end
    end
    
    reacted_polymer.length
  end

  def reacts_with(other)
    self != other and self.downcase == other.downcase
  end
end

polymer = File.read("input/day_5").chomp
puts "Part 1: #{polymer.react}"

minimal_polymer = ("a".."z").map { |ignore_unit| polymer.react(ignore_unit) }.min
puts "Part 2: #{minimal_polymer}"