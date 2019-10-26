INPUT = 3014603

def winner(elves)
  return 1 if elves <= 2
  winner_after_1_round = winner(elves / 2)

  if elves.odd?
    winner_after_1_round * 2 + 1
  else
    winner_after_1_round * 2 - 1
  end
end

puts "Part 1: #{winner(INPUT)}"

def complex_winner(elves)
  return 1 if elves <= 2

  (1..elves).inject(1) do |previous_winner, count|
    winner = (1 + previous_winner + (previous_winner >= count / 2 ? 1 : 0)) % count
    winner == 0 ? count : winner
  end
end

puts "Part 2: #{complex_winner(INPUT)}"
