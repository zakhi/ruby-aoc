class Circuit
  def initialize(operations)
    @operations = operations
    @signals = {}
  end

  def signal(wire)
    return wire.to_i if wire =~ /^\d+$/

    @signals[wire] ||= case @operations[wire]
    when /^(\w+)$/ then signal($1)
    when /(\w+) AND (\w+)/ then signal($1) & signal($2)
    when /(\w+) OR (\w+)/ then signal($1) | signal($2)
    when /NOT (\w+)/ then mask(~signal($1))
    when /(\w+) RSHIFT (\d+)/ then signal($1) >> $2.to_i
    when /(\w+) LSHIFT (\d+)/ then mask(signal($1) << $2.to_i)
    end
  end

  def set(wire, signal)
    @signals[wire] = signal
  end

  def reset
    @signals.clear
  end

  private

  def mask(value)
    value & 65535
  end
end

operations = File.readlines("input/day_7").map do |line|
  /([\w ]+) -> (\w+)/.match(line).values_at(2, 1)
end

circuit = Circuit.new(operations.to_h)
a_signal = circuit.signal("a")
puts "Part 1: #{a_signal}"

circuit.reset
circuit.set("b", a_signal)

puts "Part 2: #{circuit.signal("a")}"
