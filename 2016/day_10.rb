require "set"

class Bot
  def initialize(low_to:, high_to:)
    @low_to, @high_to = low_to, high_to
    @values = []
  end

  def values
    @values.to_set
  end

  def count
    @values.count
  end

  def <<(value)
    @values << value
  end

  def give(targets)
    targets[@high_to] << @values.max
    targets[@low_to] << @values.min
    @values.clear
  end
end

class Output
  attr_reader :value

  def <<(value)
    @value = value
  end
end

class BotProcess
  def initialize(bots, values)
    @bots = bots
    @outputs = Hash.new { |h, k| h[k] = Output.new }
    values.each { |value, bot_id| @bots[bot_id] << value }
  end

  def find_comparing(first, second)
    comparing_bot = nil

    loop do
      index, giving_bot = @bots.find { |_, bot| bot.count == 2 }
      break if giving_bot.nil?
      comparing_bot = index if giving_bot.values == Set[first, second]
      giving_bot.give(self)
    end

    comparing_bot
  end

  def [](target)
    case target.first
    when :bot then @bots[target.last]
    when :output then @outputs[target.last]
    end
  end
end

values = {}
bots = {}

File.readlines("input/day_10").map do |line|
  case line
  when /bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)/
    match = Regexp.last_match
    bots[match[1].to_i] = Bot.new(low_to: [match[2].to_sym, match[3].to_i], high_to: [match[4].to_sym, match[5].to_i])
  when /value (\d+) goes to bot (\d+)/
    match = Regexp.last_match
    values[match[1].to_i] = match[2].to_i
  end
end

process = BotProcess.new(bots, values)
bot = process.find_comparing(61, 17)
puts "Part 1: #{bot}"

output_chips = (0..2).map { |i| process[[:output, i]].value }.inject(&:*)
puts "Part 2: #{output_chips}"
