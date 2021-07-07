class Players
  attr_reader :name, :move

  POSSIBLE_MOVES = {
                     'rps' => {
                                'rock'     => Rock.new,
                                'paper'    => Paper.new,
                                'scissors' => Scissors.new
                              },

                     'ls'  =>  {
                                 'rock'     => Rock.new,
                                 'paper'    => Paper.new,
                                 'scissors' => Scissors.new,
                                 'lizard'   => Lizard.new,
                                 'spock'    => Spock.new
                               }
                    }.freeze

  BOTS = [
           Bot.new, Walle.new, R2D2.new, C3PO.new,
           BB8.new, Hal.new,   Sonny.new
         ].freeze

  def to_s
    name
  end
end

class Human < Players
  def initialize(n)
    self.name = n
  end

  def choose_move(game_type, chosen_move)
    @move = POSSIBLE_MOVES[game_type][chosen_move]
  end

  private

  attr_writer :name
end

class Computer < Players

  def choose_move(game_type)
    moves = POSSIBLE_MOVES[game_type]
    self.move = personality(game_type, moves)
  end

  def preference(moves, preferred_choice, tries)
    move_name = nil
    i = 0

    while move_name != preferred_choice && i < tries do
      move_name = moves.keys.sample
      i += 1
    end

    moves[move_name]
  end
end

class Bot < Computer
  def initialize() @name = 'Bot'; end

  def personality(game_type, moves)
    moves.values.sample
  end
end

class R2D2 < Computer
  def initialize() @name = 'R2D2'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      preference(moves, 'rock', 3)
    else
      preference(moves, ['rock', 'lizard', 'lizard'].sample, 2)
    end
  end
end

class C3PO < Computer
  def initialize() @name = 'C3PO'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      preference(moves, 'paper', 2)
    else
      preference(moves, 'spock', 3)
    end
  end
end

class BB8 < Computer
  def initialize() @name = 'BB8'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      preference(moves, ['rock', 'paper'].sample, 2)
    else
      preference(moves, ['rock', 'paper', 'lizard'].sample, 2)
    end
  end
end

class Walle < Computer
  def initialize() @name = 'Walle'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      moves[ 'scissors']
    else
      move_name = ['scissors', 'spock'].sample
      moves[move_name]
    end
  end
end

class Sonny < Computer
  def initialize() @name = 'Sonny'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      moves['paper']
    else
      move_name = ['paper', 'spock', 'spock'].sample
      moves[move_name]
    end
  end
end

class Hal < Computer
  def initialize() @name = 'Hal'; end

  def personality(game_type, moves)
    if game_type == 'rps'
      preference(moves, 'rock', 3)
    else
      moves['spock']
    end
  end
end
