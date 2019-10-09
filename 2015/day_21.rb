Equipment = Struct.new(:name, :cost, :damage, :armor, keyword_init: true)

Fighter = Struct.new(:hit_points, :damage, :armor, keyword_init: true) do
  def hit_sustain(hit_damage)
    points_lost = [hit_damage - armor, 1].max
    hit_points / points_lost
  end
end

class ItemSets
  def initialize(weapons, armor, rings)
    weapon_choices = weapons
    armor_choices = combinations(armor, 0..1)
    ring_choices = combinations(rings, 0..2)

    @sets = weapon_choices.product(armor_choices).product(ring_choices).map(&:flatten)
  end

  def lowest_cost_winning(boss)
    @sets.select { |items| wins?(items, boss) }.map { |items| items.sum(&:cost) }.min
  end

  def highest_cost_losing(boss)
    @sets.reject { |items| wins?(items, boss) }.map { |items| items.sum(&:cost) }.max
  end

  private

  def combinations(items, range)
    range.flat_map { |count| items.combination(count).to_a }
  end

  def wins?(items, boss)
    player = Fighter.new(hit_points: 100, damage: items.sum(&:damage), armor: items.sum(&:armor))
    player.hit_sustain(boss.damage) >= boss.hit_sustain(player.damage)
  end
end

weapons = [
  Equipment.new(name: "Dagger",     cost: 8,  damage: 4, armor: 0),
  Equipment.new(name: "Shortsword", cost: 10, damage: 5, armor: 0),
  Equipment.new(name: "Warhammer",  cost: 25, damage: 6, armor: 0),
  Equipment.new(name: "Longsword",  cost: 40, damage: 7, armor: 0),
  Equipment.new(name: "Greataxe",   cost: 74, damage: 8, armor: 0)
]

armor = [
  Equipment.new(name: "Leather",    cost: 13,  damage: 0, armor: 1),
  Equipment.new(name: "Chainmail",  cost: 31,  damage: 0, armor: 2),
  Equipment.new(name: "Splintmail", cost: 53,  damage: 0, armor: 3),
  Equipment.new(name: "Bandedmail", cost: 75,  damage: 0, armor: 4),
  Equipment.new(name: "Platemail",  cost: 102, damage: 0, armor: 5)
]

rings = [
  Equipment.new(name: "Damage +1",  cost: 25,  damage: 1, armor: 0),
  Equipment.new(name: "Damage +2",  cost: 50,  damage: 2, armor: 0),
  Equipment.new(name: "Damage +3",  cost: 100, damage: 3, armor: 0),
  Equipment.new(name: "Defense +1", cost: 20,  damage: 0, armor: 1),
  Equipment.new(name: "Defense +2", cost: 40,  damage: 0, armor: 2),
  Equipment.new(name: "Defense +3", cost: 80,  damage: 0, armor: 3)
]

input = File.read("input/day_21")
boss = Fighter.new(
    hit_points: /Hit Points: (\d+)/.match(input)[1].to_i,
    damage: /Damage: (\d+)/.match(input)[1].to_i,
    armor: /Armor: (\d+)/.match(input)[1].to_i
)

item_sets = ItemSets.new(weapons, armor, rings)
puts "Part 1: #{item_sets.lowest_cost_winning(boss)}"
puts "Part 2: #{item_sets.highest_cost_losing(boss)}"
