require_relative "../helpers/enumerable"

Room = Struct.new(:name, :sector, :checksum) do
  def real?
    sorted_letters = name.delete("-").each_char.tally.sort_by { |letter, count| [-count, letter] }.map(&:first)
    sorted_letters.take(5).join == checksum
  end

  def decrypted
    decrypted_chars = name.each_char.map do |char|
      case char
      when "-" then " "
      else
        new_offset = (char.ord - "a".ord + sector) % 26
        (new_offset + "a".ord).chr
      end
    end
    decrypted_chars.join
  end
end

rooms = File.readlines("input/day_4").map do |line|
  name, sector, checksum = /([a-z-]+)(\d+)\[([a-z]{5})\]/.match(line)[1..3]
  Room.new(name, sector.to_i, checksum)
end

real_rooms_sum = rooms.select(&:real?).map(&:sector).sum
puts "Part 1: #{real_rooms_sum}"

storage_room = rooms.find { |room| room.decrypted.include?("northpole")  }
puts "Part 2: #{storage_room.sector}"
