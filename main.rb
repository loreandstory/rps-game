$LOAD_PATH << "."

require 'moves'
require 'players'
require 'game'
require 'pages'

$game_type = 'rps' # default starting setting.

BOTS = [
         Bot.new, Walle.new, R2D2.new, C3PO.new,
         BB8.new, Hal.new,   Sonny.new
       ].freeze

game = Game.new

player = Human.new(Page::PlayerName.new.interface_with_user)

$game_type = Page::GameType.new("#{player.name}").interface_with_user

def play(player, game)
  computer = BOTS.sample

  player.move = Page::ChooseMove.new("#{computer.name}").interface_with_user
  computer.move = computer.personality

  game.update(player, computer)
  Page::Results.new(game.history)

  game.update_stats
end

play(player, game)
