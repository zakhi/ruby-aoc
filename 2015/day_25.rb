def code_index_at(row, column)
  1 + (1 .. row - 1).sum + (row + 1 .. row + column - 1).sum
end

def modular_pow(base, exponent, modulus)
  return 0 if modulus == 1
  base = base % modulus
  result = 1

  while exponent > 0
    result = (result * base) % modulus if exponent.odd?
    exponent >>= 1
    base = (base ** 2) % modulus
  end

  result
end

row, column = File.read("input/day_25").match(/row (\d+), column (\d+)/)[1..2].map(&:to_i)
exponent = code_index_at(row, column) - 1
base = 252533
modulus = 33554393

result = 20151125 * modular_pow(base, exponent, modulus) % modulus
puts "Part 1: #{result}"
