require "set"

class KnotHash
  def hash(string)
    lengths = string.chars.map(&:ord) + [17, 31, 73, 47, 23]
    elements = (0..255).to_a
    skip = 0
    position = 0

    64.times do
      lengths.each do |length|
        reverse(position, length, elements)
        position = (position + length + skip) % elements.size
        skip += 1
      end
    end

    dense_hash = elements.each_slice(16).map { |slice| slice.reduce(&:^) }
    dense_hash.map { |e| "%02x" % e }.join
  end

  def reverse(position, length, elements)
    (length / 2).times do |i|
      first_index = (position + i) % elements.size
      second_index = (position + length - 1 - i) % elements.size
      elements[first_index], elements[second_index] = elements[second_index], elements[first_index]
    end
  end
end

INPUT = "wenycdww"

used = 128.times.each_with_object(Set[]) do |row, used|
  hash = KnotHash.new.hash("#{INPUT}-#{row}")
  bits = hash.each_char.map { |digit| "%04b" % digit.hex }.join
  bits.each_char.with_index { |char, column| used << [column, row] if char == "1" }
end

puts "Part 1: #{used.count}"

links = Hash.new { |h, k| h[k] = [] }

used.each do |square|
  [[0, 1], [0, -1], [1, 0], [-1, 0]].map { |offset| square.zip(offset).map(&:sum) }.each do |neighbor|
    links[square] << neighbor if used.include?(neighbor)
  end
end

used_left = used.to_a
groups = []

until used_left.empty?
  queue = [used_left.first]
  group = Set[]

  until queue.empty?
    current = queue.pop
    group << current
    used_left.delete(current)

    links[current].each { |square| queue << square unless group.include?(square) }
  end

  groups << group
end

puts "Part 2: #{groups.count}"
