require "prime"

INPUT = "00101000101111010"

class Filler
  def fill_checksum(length:)
    filler = fill(length)
    calculate_checksum(filler)
  end

  def fill(length)
    filler = INPUT.each_char.map(&:to_i).to_a

    while filler.length < length
      filler << 0
      filler.reverse_each.lazy.drop(1).each { |e| filler << (e == 0 ? 1 :0) }
    end

    filler[0...length]
  end

  def calculate_checksum(filler)
    two_factor = filler.length.prime_division.to_h[2]
    return filler.join if two_factor.nil?

    filler.each_slice(2 ** two_factor).map { |slice| slice.count(1).even? ? 1 : 0 }.join
  end
end

filler = Filler.new

puts "Part 1: #{filler.fill_checksum(length: 272)}"
puts "Part 2: #{filler.fill_checksum(length: 35651584)}"
