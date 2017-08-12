require "./lib.rb"

move = ""
move_count = 0
game = Quadruple.new
game.print_instructions
game.draw

loop do
  print "\n>"
  move = gets.strip
  move_count += 1

  feedback = game.update(move)
  game.draw

  break if feedback == "gameover" or move == "exit"
end

if move == "exit"
  puts "Sorry, play again sometime."
else
  puts "Hooray! It took you #{move_count} moves to score #{game.score}."
end
