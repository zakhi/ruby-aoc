class Step
  attr_reader :letter, :depends_on, :time_left

  def initialize(letter)
    @letter = letter
    @time_left = letter.ord - "A".ord + 61
    @depends_on = []
  end

  def can_start?
    !completed? and @depends_on.all?(&:completed?)
  end

  def completed?
    @time_left == 0
  end
  
  def work(seconds=@time_left)
    @time_left -= seconds
  end
end


Rules = File.readlines("input/day_7").map do |line|
  /Step (\w) must be finished before step (\w) can begin/.match(line)[1..2]
end

def create_steps
  steps = Rules.flat_map(&:itself).uniq.map { |letter| [letter, Step.new(letter)] }.to_h
  Rules.each do |dependency, dependent|
    steps[dependent].depends_on << steps[dependency]
  end
  steps.values
end

steps = create_steps
steps_taken = []

until steps.all?(&:completed?)
  next_step = steps.find(&:can_start?)
  steps_taken << next_step.letter
  next_step.work
end

puts "Part 1: #{steps_taken.join}"

class Worker
  def assign(step)
    @step = step
  end

  def idle?
    @step.nil?
  end

  def work
    if @step
      @step.work(1)
      @step = nil if @step.completed?
    end
  end
end

steps = create_steps
steps_left = steps.clone
workers = 5.times.map { Worker.new }
time = 0

until steps.all?(&:completed?)
  loop do
    worker = workers.find(&:idle?)
    step = steps_left.find(&:can_start?)

    break unless worker and step
    worker.assign(step)
    steps_left.delete(step)
  end

  workers.each(&:work)
  time += 1
end

puts "Part 2: #{time}"
