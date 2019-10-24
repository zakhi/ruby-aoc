require "digest"

INPUT = "cuanljph"

class KeyGenerator
  include Enumerable

  def initialize(stretch: 0)
    @stretch = stretch
    @hashes = []
    @index = 0
    @quintuple_counts = Hash.new(0)
    1000.times { add }
  end

  def each
    loop do
      hash, index = pop
      match = hash.match(/(\w)\1\1/)
      next unless match
      yield index if @quintuple_counts[match[1]] > 0
    end
  end

  def add
    hash = (@stretch + 1).times.inject("#{INPUT}#{@index}") { |hash, _| Digest::MD5.hexdigest(hash) }
    @hashes << [hash, @index]
    @index += 1
    update_quintuple_counts(hash)
  end

  def pop
    add
    @hashes.shift.tap do |hash, _|
      update_quintuple_counts(hash, remove: true)
    end
  end

  def update_quintuple_counts(hash, remove: false)
    hash.scan(/(\w)\1{4}/).flatten.each do |char|
      @quintuple_counts[char] += (remove ? -1 : 1)
    end
  end
end

generator = KeyGenerator.new
puts "Part 1: #{generator.take(64).last}"

complex_generator = KeyGenerator.new(stretch: 2016)
puts "Part 2: #{complex_generator.take(64).last}"
