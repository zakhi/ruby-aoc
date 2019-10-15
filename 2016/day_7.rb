class String
  def supernet_sequences
    split(/\[.*?\]/)
  end

  def hypernet_sequences
    scan(/\[(.*?)\]/).flatten
  end

  def include_abba?
    match = match(/(\w)(\w)\2\1/)
    match && match[1] != match[2]
  end

  def aba
    scan(/(?=((\w)(\w)\2))/).select { |match| match[1] != match[2] }.map(&:first)
  end
end

addresses = File.readlines("input/day_7").map(&:chomp)

support_tls = addresses.count do |address|
  address.supernet_sequences.any?(&:include_abba?) && address.hypernet_sequences.none?(&:include_abba?)
end

puts "Part 1: #{support_tls}"

support_ssl = addresses.count do |address|
  address.supernet_sequences.flat_map(&:aba).any? do |aba|
    address.hypernet_sequences.any? { |s| s.include?("#{aba[1..]}#{aba[1]}")}
  end
end
puts "Part 2: #{support_ssl}"
