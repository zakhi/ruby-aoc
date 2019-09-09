require "set"

class Player
  attr_reader :type, :position, :hit_points

  def initialize(type, position, attack_power)
    @type = type
    @position = position
    @attack_power = attack_power
    @hit_points = 200
  end

  def alive?
    hit_points > 0
  end

  def dead?
    !alive?
  end

  def elf?
    type == "E"
  end

  def at?(position)
    @position == position
  end

  def move_to(position)
    @position = position
  end

  def attack(other)
    other.suffer(@attack_power)
  end

  def suffer(lost_hit_points)
    @hit_points = [0, @hit_points - lost_hit_points].max
  end

  def to_s
    "#{type}(#{hit_points})"
  end
end

class Combat
  def initialize(field, elf_attack_power: 3, display: false)
    @players = field.select { |*, char| char =~ /E|G/ }.map do |pos, char|
      Player.new(char, pos, char == "E" ? elf_attack_power : 3)
    end

    @field = field.transform_values { |char| char =~ /E|G/ ? "." : char }
    @completed_rounds = 0
    @elf_attack_power = elf_attack_power
    @display = display
  end

  def play_out(until_elf_dies: false)
    show if @display
    while !completed?
      alive_players.sort_by(&:position).each do |player|
        next if player.dead?
        return if enemies_of(player).empty?

        move(player)
        nearby_enemy = nearby_enemy_of(player)

        if nearby_enemy
          player.attack(nearby_enemy)
          return if until_elf_dies and nearby_enemy.elf? and nearby_enemy.dead?
        end
      end
      @completed_rounds += 1
      show if @display
    end
  end

  def completed?
    alive_players.map(&:type).uniq.size == 1
  end

  def winner
    completed? ? alive_players.first.type : nil
  end

  def outcome
    @completed_rounds * alive_players.map(&:hit_points).sum
  end

  def enemies_of(player)
    alive_players.select { |other| other.type != player.type }
  end

  def alive_players
    @players.select(&:alive?)
  end

  def nearby_enemy_of(player)
    enemies = enemies_of(player)
    adjacents = adjacent_positions_of(player.position)
    adjacents.map { |p| enemies.find { |enemy| enemy.at?(p) } }.reject(&:nil?).min_by(&:hit_points)
  end

  def adjacent_positions_of(position)
    candidates = [[-1, 0], [0, -1], [0, 1], [1, 0]].map { |dy, dx| [position.first + dy, position.last + dx] }
    candidates.select { |pos| @field[pos] == "." }
  end

  def move(player)
    target = find_target(player) or return
    return if target == player.position

    new_position = next_step_to(target, from: player.position)
    player.move_to(new_position)
  end

  def find_target(player)
    enemies = enemies_of(player)
    scan_from(player.position) do |position|
      enemies.any? { |enemy| enemy.at?(position) }
    end
  end

  def next_step_to(to, from:)
    scan_from(to) do |position|
      position == from
    end
  end

  def scan_from(start)
    next_positions = Set[[0,start]]
    visited = Set[]

    until next_positions.empty?
      distance, current_position = next_positions.min
      next_positions.delete(next_positions.min)
      adjacents = adjacent_positions_of(current_position).reject { |p| visited.include?(p) }
      return current_position if adjacents.any? { |adj| yield adj }

      visited << current_position
      next_positions.merge(adjacents.select { |adj| free?(adj) }.map { |adj| [distance + 1, adj] } )
    end
  end

  def free?(position)
    @field[position] == "." and !alive_players.any? { |player| player.at?(position) }
  end

  def show
    totals = @field.keys.max
    rows = Array.new(totals.first + 1) { Array.new(totals.last + 1) }
    players_in_rows = Array.new(totals.first + 1) { Array.new }

    @field.sort_by(&:first).each do |(y, x), char|
      player = alive_players.find { |player| player.at?([y, x]) }
      players_in_rows[y] << player if player
      rows[y][x] = player ? player.type : char
    end

    puts
    puts "After #{@completed_rounds} rounds (Elf attack power: #{@elf_attack_power})" 
    rows.zip(players_in_rows) do |row, players|
      puts "#{row.join} #{players.join(", ")}"
    end
  end
end

field = {}

File.readlines("input/day_15").each_with_index.map do |line, y|
  line.chomp.each_char.with_index do |char, x|
    field[[y, x]] = char
  end
end

combat = Combat.new(field)
combat.play_out

puts "Part 1: #{combat.outcome}"

4.step.each do |attack_power|
  combat = Combat.new(field, elf_attack_power: attack_power)

  combat.play_out(until_elf_dies: true)
  break combat if combat.completed? and combat.winner == "E"
end

puts "Part 2: #{combat.outcome}"
