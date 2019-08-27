require "strscan"

class Scanner
  def initialize(file)
    @scanner = StringScanner.new(File.read(file))
  end

  def next(count)
    count.times.map { @scanner.scan(/\d+\s*/).strip.to_i }
  end
end

class Node
  def initialize(children, metadata)
    @children = children
    @metadata = metadata
  end

  def total_metadata
    @children.sum(&:total_metadata) + @metadata.sum
  end

  def value
    return @metadata.sum if @children.empty? 
    @metadata.select(&:positive?).map { |i| @children[i - 1] }.compact.sum(&:value)
  end
end

def read_node(input)
  child_count, metadata_count = input.next(2)
  children = child_count.times.map { read_node(input) }
  metadata = input.next(metadata_count)
  Node.new(children, metadata)
end

root_node = read_node(Scanner.new("input/day_8"))

puts "Part 1: #{root_node.total_metadata}"
puts "Part 2: #{root_node.value}"
