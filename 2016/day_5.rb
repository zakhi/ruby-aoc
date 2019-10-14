require "digest"

def zero_starting_hashes(input)
  Enumerator.new do |y|
    1000000.step do |i|
      hash = Digest::MD5.hexdigest("#{input}#{i}")
      y << hash if hash.start_with?("00000")
    end
  end
end

INPUT = "ojvtpuvg"

code = zero_starting_hashes(INPUT).take(8).map { |hash| hash[5] }.join
puts "Part 1: #{code}"

second_code = Array.new(8)

zero_starting_hashes(INPUT).take_while do |hash|
  case position = hash[5]
  when /[^0-7]/ then true
  else
    second_code[position.to_i] ||= hash[6]
    second_code.include?(nil)
  end
end

puts "Part 2: #{second_code.join}"
