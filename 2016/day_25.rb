def creates_clock_signal?(number)
  first, first_out = number.divmod(2)
  return false unless first > 0 && first_out == 0

  second, second_out = first.divmod(2)
  return false unless second_out == 1

  second == 0 ? true : creates_clock_signal?(second)
end

initialization = 0.step.find { |i| creates_clock_signal?(2541 + i) }
puts "Part 1: #{initialization}"
