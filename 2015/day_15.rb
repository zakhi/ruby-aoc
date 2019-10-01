Ingredient = Struct.new(:name, :capacity, :durability, :flavor, :texture, :calories) do
  def [](property)
    send(property)
  end
end

class CookieRecipeMaker
  Recipe = Struct.new(:score, :calories)
  SCORE_PROPERTIES = [:capacity, :durability, :flavor, :texture]

  def initialize(ingredients)
    @ingredients = ingredients.map { |i| [i.name, i] }.to_h
    @recipes = []
  end

  def calculate
    combinations.each do |combination|
      property_scores = SCORE_PROPERTIES.map do |property|
        combination.sum { |name, amount| @ingredients[name][property] * amount }
      end
      calories = combination.sum { |name, amount| @ingredients[name].calories * amount }
      @recipes << Recipe.new(property_scores.inject(&:*), calories) if property_scores.all?(&:positive?)
    end
  end

  def best_recipe_score(calories: nil)
    recipes = calories.nil? ? @recipes : @recipes.select { |r| r.calories == calories }
    recipes.map(&:score).max
  end

  def combinations
    Enumerator.new do |yielder|
      names = @ingredients.keys
      (99 + names.size).times.to_a.combination(names.size - 1).each do |combination|
        amounts = { names.first => combination.first, names.last => 98 + names.size - combination.last }
        combination.each_cons(2).map { |a, b| b - a - 1 }.zip(names[1...-1]).each do |amount, name|
          amounts[name] = amount
        end
        yielder << amounts
      end
    end
  end
end

ingredients = File.readlines("input/day_15").map do |line|
  match = /(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/.match(line)
  Ingredient.new(match[1].to_sym, *match[2..6].map(&:to_i))
end

recipe_maker = CookieRecipeMaker.new(ingredients)
recipe_maker.calculate

puts "Part 1: #{recipe_maker.best_recipe_score}"
puts "Part 2: #{recipe_maker.best_recipe_score(calories: 500)}"
