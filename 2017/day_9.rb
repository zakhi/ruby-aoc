class StreamProcessor
  attr_reader :total_score, :total_garbage

  def initialize(stream)
    @stream = stream
  end

  def process
    @state = :group
    @score = 0
    @total_score = 0
    @total_garbage = 0

    @stream.each do |char|
      case @state
      when :group then process_in_group(char)
      when :garbage then process_in_garbage(char)
      when :escaped then @state = :garbage
      end
    end
  end

  def process_in_group(char)
    case char
    when "{" then @score += 1
    when "<" then @state = :garbage
    when "}"
      @total_score += @score
      @score -= 1
    end
  end

  def process_in_garbage(char)
    case char
    when ">" then @state = :group
    when "!" then @state = :escaped
    else @total_garbage += 1
    end
  end
end

stream = File.read("input/day_9").chomp.each_char
processor = StreamProcessor.new(stream)
processor.process

puts "Part 1: #{processor.total_score}"
puts "Part 2: #{processor.total_garbage}"
