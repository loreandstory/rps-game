$LOAD_PATH << "."

require 'moves'
require 'players'
require 'game'

=begin
  Functionality fully inplemented, but need to flesh out display module
  to get displaying nicely and in a way the user will find engaging.

  Below is a temporary, basic, and crude implementation of a
  working Rock Paper Scissors/Lizard Spock game for a user to play.
=end

BOTS = [
         Computer.new, Walle.new, R2D2.new, C3PO.new,
         BB8.new,      Hal.new,   Sonny.new
       ].freeze

def play(player, game)
  system('clear')
  computer = BOTS.sample
  print "\n#{player.name}, you are playing against: #{computer.name}\n\n"

  print "Choose your move...\n\n"
  player.choose_move(game.type)
  computer.choose_move(game.type)

  print "\nYou chose: #{player.move}"
  puts "\n#{computer.name} chose: #{computer.move}\n"
  game.update(player, computer)

  print "\nThe winner is ==> #{game.winner}!\n\n"
  game.print_score

  print "\n\nKeep playing? (y/n): "
  return unless ['Y', 'y', 'yes'].include? gets.chomp
  play(player, game)
end

system('clear')
player = Human.new
game = Game.new

play(player, game)
puts
game.tally_stats
p game.stats
