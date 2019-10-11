class Spell
  class << self
    attr_accessor :cost
  end

  def initialize(turns_left: 1)
    @turns_left = turns_left
  end

  def cost
    self.class.cost
  end

  def in_effect?
    @turns_left > 0
  end

  def affect(boss, player)
    @turns_left -= 1
  end
end

class MagicMissile < Spell
  self.cost = 53

  def affect(boss, player)
    super
    boss.suffer(4)
  end
end

class Drain < Spell
  self.cost = 73

  def affect(boss, player)
    super
    boss.suffer(2)
    player.gain(2)
  end
end

class Shield < Spell
  self.cost = 113

  def initialize
    super(turns_left: 6)
  end

  def affect(boss, player)
    super
    player.armor = 7
  end
end

class Poison < Spell
  self.cost = 173

  def initialize
    super(turns_left: 6)
  end

  def affect(boss, player)
    super
    boss.suffer(3)
  end
end

class Recharge < Spell
  self.cost = 229

  def initialize
    super(turns_left: 5)
  end

  def affect(boss, player)
    super
    player.mana += 101
  end
end

module Player
  def dead?
    @hit_points == 0
  end

  def suffer(damage)
    @hit_points = [0, @hit_points - damage].max
  end

  def gain(life)
    @hit_points += life
  end
end

class Boss
  include Player

  def initialize(hit_points:, damage:)
    @hit_points, @damage = hit_points, damage
  end

  def attack(player)
    player.suffer(@damage)
  end
end

class Wizard
  include Player

  attr_accessor :mana
  attr_reader :mana_spent
  attr_writer :armor

  def initialize(hit_points:, mana:, penalty: 0, mana_spent: 0)
    @hit_points, @mana, @penalty, @mana_spent = hit_points, mana, penalty, mana_spent
    @armor = 0
  end

  def dup
    super.tap { |p| p.armor = 0 }
  end

  def can_spend?(amount)
    @mana >= amount
  end

  def cast(spell)
    @mana -= spell.cost
    @mana_spent += spell.cost
  end

  def suffer(amount)
    super(amount - @armor)
  end

  def penalize
    suffer(@penalty)
  end
end


class Turn
  SPELLS = [MagicMissile, Drain, Shield, Poison, Recharge]

  def initialize(wizard, boss, current, spells, last_cast_spell: nil)
    @wizard, @boss, @current, @spells = wizard.dup, boss.dup, current, spells.map(&:dup)
    if last_cast_spell
      @wizard.cast(last_cast_spell)
      @spells << last_cast_spell
    end
  end

  def play_out
    @wizard.penalize if @current == :wizard
    return nil if @wizard.dead?

    @spells.each { |spell| spell.affect(@boss, @wizard) }
    return @wizard.mana_spent if @boss.dead?

    case @current
    when :boss
      @boss.attack(@wizard)
      @wizard.dead? ? nil : play_next_turn
    when :wizard
      valid_spells_types = SPELLS.select do |kind|
        @wizard.can_spend?(kind.cost) && @spells.none? { |spell| spell.is_a?(kind) && spell.in_effect? }
      end

      if valid_spells_types.empty?
        play_next_turn
      else
        spent_manas = valid_spells_types.map(&:new).map do |spell|
          play_next_turn(cast_spell: spell)
        end

        spent_manas.compact.min
      end
    end
  end

  def play_next_turn(cast_spell: nil)
    next_player = @current == :boss ? :wizard : :boss
    next_turn = Turn.new(@wizard, @boss, next_player, @spells.select(&:in_effect?), last_cast_spell: cast_spell)
    next_turn.play_out
  end
end


input = File.read("input/day_22")
boss = Boss.new(
  hit_points: /Hit Points: (\d+)/.match(input)[1].to_i,
  damage: /Damage: (\d+)/.match(input)[1].to_i
)

wizard = Wizard.new(hit_points: 50, mana: 500)

lowest_mana_in_win = Turn.new(wizard, boss.dup, :wizard, []).play_out
puts "Part 1: #{lowest_mana_in_win}"

penalized_wizard = Wizard.new(hit_points: 50, mana: 500, penalty: 1)
lowest_mana_in_penalized_win = Turn.new(penalized_wizard, boss, :wizard, []).play_out
puts "Part 2: #{lowest_mana_in_penalized_win}"
