INPUT = 633601

class Recipes
  def initialize
    @recipes = [3, 7]
    @first_index = 0
    @second_index = 1
  end

  def size
    @recipes.size
  end

  def [](*args)
    @recipes[*args]
  end

  def make_new
    new_recipe = @recipes[@first_index] + @recipes[@second_index]
    @recipes.push(*new_recipe.digits.reverse)
    @first_index = (@first_index + 1 + @recipes[@first_index]) % @recipes.size
    @second_index = (@second_index + 1 + @recipes[@second_index]) % @recipes.size
  end
end

first_recipes = Recipes.new
first_recipes.make_new while first_recipes.size < INPUT + 10

puts "Part 1: #{first_recipes[INPUT, 10].join}"

INPUT_DIGITS = INPUT.digits.reverse
INPUT_SIZE = INPUT_DIGITS.size

def match(recipes, start_index)
  INPUT_SIZE.times.all? { |i| recipes[start_index + i] == INPUT_DIGITS[i] }
end

second_recipes = Recipes.new

recipe_count = loop do
  break second_recipes.size - INPUT_SIZE if match(second_recipes, second_recipes.size - INPUT_SIZE)
  break second_recipes.size - INPUT_SIZE - 1 if match(second_recipes, second_recipes.size - INPUT_SIZE - 1)
  second_recipes.make_new
end

puts "Part 2: #{recipe_count}"
