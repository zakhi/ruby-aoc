require "prime"

INPUT = 36_000_000

def divisors_sum(number)
  number.prime_division.map { |p, m| (p ** (m + 1) - 1) / (p - 1) }.inject(&:*)
end

lowest_house_number = 800_000.step.find do |i|
  divisors_sum(i) * 10 >= INPUT
end

puts "Part 1: #{lowest_house_number}"

def divisors(number)
  Enumerator.new do |y|
    y << 1
    factors = number.prime_division.flat_map { |p, m| [p] * m }
    (1..factors.size).each do |i|
      factors.combination(i).uniq.each do |factor_group|
        y << factor_group.inject(&:*)
      end
    end
  end
end

lowest_house_number_limited = 800_000.step.find do |i|
  divisors(i).reject { |d| d * 50 < i }.sum * 11 >= INPUT
end

puts "Part 2: #{lowest_house_number_limited}"