require "strscan"

def decompressed_length(compressed, version: 1)
  length = 0
  scanner = StringScanner.new(compressed)

  until scanner.eos?
    if scanner.scan(/\((\d+)x(\d+)\)/)
      chars, times = scanner.values_at(1, 2).map(&:to_i)
      length += times * case version
        when 1 then chars
        when 2 then decompressed_length(scanner.post_match[0, chars], version: 2)
      end

      scanner.pos += chars
    else
      scanner.pos += 1
      length += 1
    end
  end

  length
end

compressed = File.read("input/day_9").chomp

puts "Part 1: #{decompressed_length(compressed)}"
puts "Part 2: #{decompressed_length(compressed, version: 2)}"
