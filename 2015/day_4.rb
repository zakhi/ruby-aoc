require "digest"

INPUT = "ckczppom"

def find_start_zeros(number)
  expected = "0" * number

  1.step.find do |i|
    digest = Digest::MD5.hexdigest("#{INPUT}#{i}")
    digest.start_with?(expected)
  end
end

puts "Part 1: #{find_start_zeros(5)}"
puts "Part 2: #{find_start_zeros(6)}"
