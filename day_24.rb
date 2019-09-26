class Group
  include Comparable
  attr_reader :army, :units, :damage, :initiative

  def initialize(army, description, boost=0)
    @army, @boost = army, boost
    @units, @hit_points = /^(\d+) units each with (\d+) hit points/.match(description)[1..2].map(&:to_i)
    @weaknesses = parse_modifiers(/weak to ([a-z ,]+)[;)]/.match(description))
    @immunities = parse_modifiers(/immune to ([a-z ,]+)[;)]/.match(description))
    @attack = /attack that does (\d+)/.match(description)[1].to_i + (army == :immune_system ? boost : 0)
    @damage = /(\w+) damage/.match(description)[1].to_sym
    @initiative = /at initiative (\d+)/.match(description)[1].to_i
  end

  def empty?
    @units == 0
  end

  def effective_power
    @units * @attack
  end

  def suffer(attack, damage)
    actual_damage = attack * multiplier(damage)
    @units = [0, @units - actual_damage / @hit_points].max
  end
  
  def multiplier(damage)
    case
    when @immunities.include?(damage) then 0
    when @weaknesses.include?(damage) then 2
    else 1
    end
  end

  def <=>(other)
    [other.effective_power, other.initiative] <=> [self.effective_power, self.initiative]
  end

  def parse_modifiers(match)
    match ? match[1].split(", ").map(&:to_sym) : []
  end
end

class Combat
  def initialize(groups)
    @groups = groups
  end

  def fight
    previous_units_left = units_left
    while winner == :none
      select_targets.sort_by { |attacker, *| -attacker.initiative }.each do |attacker, target|
        target.suffer(attacker.effective_power, attacker.damage)        
      end
      break if units_left == previous_units_left
      previous_units_left = units_left
    end
  end

  def winner
    valid_groups.map(&:army).uniq.size == 1 ? valid_groups.first.army : :none
  end

  def units_left
    @groups.map(&:units).sum
  end

  def select_targets
    targets_left = valid_groups.clone
    selections = valid_groups.sort.map do |attacker|
      valid_targets = targets_left.reject { |target| target.army == attacker.army || target.multiplier(attacker.damage) == 0 }

      selected_target = valid_targets.max_by do |target| 
        damage = attacker.effective_power * target.multiplier(attacker.damage)
        [damage, target.effective_power, target.initiative]
      end

      selected_target ? [attacker, targets_left.delete(selected_target)] : nil
    end
    selections.compact
  end

  def valid_groups
    @groups.reject(&:empty?)
  end
end

groups = File.open("input/day_24") do |file|
  [:immune_system, :infection].flat_map do |army|
    groups = []
    file.gets

    loop do
      line = file.gets
      break if line.nil? || line.chomp.empty?
      groups << [army, line]
    end
    groups
  end
end

combat = Combat.new(groups.map { |army, line| Group.new(army, line) })
combat.fight
puts "Part 1: #{combat.units_left}"

units_left = 1.step do |boost|
  combat = Combat.new(groups.map { |army, line| Group.new(army, line, boost) })
  combat.fight
  break combat.units_left if combat.winner == :immune_system
end

puts "Part 2: #{units_left}"