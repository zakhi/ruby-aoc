INPUT = "hepxcrrq"

class PasswordGenerator
  def initialize(password)
    @password = password
  end

  def next_valid
    begin
      increment
    end until valid?
    @password
  end

  private

  def increment
    @password.next!.gsub!(/[ilo]/) { |match| match.next }
  end

  def valid?
    has_sequence? && has_pairs?
  end

  def has_sequence?
    @password.each_char.each_cons(3).any? do |c1, c2, c3|
      c2.ord == c1.ord + 1 && c3.ord == c2.ord + 1
    end
  end

  def has_pairs?
    @password.scan(/(\w)\1/).size > 1
  end
end

generator = PasswordGenerator.new(INPUT)

puts "Part 1: #{generator.next_valid}"
puts "Part 2: #{generator.next_valid}"
