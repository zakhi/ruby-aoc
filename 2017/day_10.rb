class KnotHash
  attr_reader :elements

  def initialize
    @elements = (0..255).to_a
    @skip = 0
  end

  def process(lengths, rounds: 1)
    position = 0

    rounds.times do
      lengths.each do |length|
        reverse(position, length)
        position = (position + length + @skip) % @elements.size
        @skip += 1
      end
    end
  end

  def hash
    dense_hash = @elements.each_slice(16).map { |slice| slice.reduce(&:^) }
    dense_hash.map { |e| "%02x" % e }.join
  end

  def reverse(position, length)
    (length / 2).times do |i|
      first_index = (position + i) % @elements.size
      second_index = (position + length - 1 - i) % @elements.size
      @elements[first_index], @elements[second_index] = @elements[second_index], @elements[first_index]
    end
  end
end

lengths = File.read("input/day_10").scan(/\d+/).map(&:to_i)

hash = KnotHash.new
hash.process(lengths)

checksum = hash.elements.take(2).inject(&:*)
puts "Part 1: #{checksum}"

code_lengths = File.read("input/day_10").chomp.each_char.map(&:ord) + [17, 31, 73, 47, 23]

code_hash = KnotHash.new
code_hash.process(code_lengths, rounds: 64)

puts "Part 2: #{code_hash.hash}"
