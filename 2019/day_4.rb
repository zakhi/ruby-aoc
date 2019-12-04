INPUT = 124075..580769

def valid_password(password, limit_adjacents: false)
  digit_pairs = password.digits.each_cons(2)
  digit_pairs.all? { |a, b| a >= b } && digit_pairs.any? { |a, b| a == b && (!limit_adjacents || password.digits.count(a) == 2) }

end

valid_passwords = INPUT.count { |number| valid_password(number) }
puts "Part 1: #{valid_passwords}"

actual_valid_passwords = INPUT.count { |number| valid_password(number, limit_adjacents: true) }
puts "Part 1: #{actual_valid_passwords}"
